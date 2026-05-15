import asyncio
import json
import logging
import time
from collections.abc import AsyncIterator
from typing import Any

from langchain.agents.agent_types import AgentType
from langchain_community.agent_toolkits.sql.base import create_sql_agent
from langchain_community.agent_toolkits.sql.toolkit import SQLDatabaseToolkit
from langchain_groq import ChatGroq

from app.core.config import settings
from app.core.exceptions import AppError, ServiceUnavailableError
from app.schemas.agent import SQLAgentRequest, SQLAgentResponse, SQLAgentStreamEvent
from app.services.agents.callbacks import StreamingEventCallback
from app.services.agents.prompts import SQL_AGENT_PREFIX, SQL_AGENT_SUFFIX
from app.services.agents.tools import SQLValidationError, get_sql_tool_router
from app.utils.trace import get_trace_id

logger = logging.getLogger(__name__)


class SQLAgentService:
    def __init__(self) -> None:
        self._tool_router = None

    @property
    def tool_router(self):
        if self._tool_router is None:
            self._tool_router = get_sql_tool_router()
        return self._tool_router

    async def run(self, request: SQLAgentRequest) -> SQLAgentResponse:
        started_at = time.perf_counter()
        try:
            payload = await self._run_with_retries(request)
            sql = self._extract_sql(payload)
            rows = (
                await self._execute_sql(sql, limit=request.top_k or settings.sql_agent_top_k)
                if sql
                else []
            )
            answer = str(payload.get("output", ""))
        except SQLValidationError as exc:
            raise AppError(str(exc), status_code=422, error_code="invalid_sql") from exc
        except AppError:
            raise
        except Exception as exc:
            logger.exception("SQL agent execution failed")
            raise ServiceUnavailableError("SQL agent execution failed.") from exc

        execution_time = round(time.perf_counter() - started_at, 4)
        logger.info(
            "SQL agent completed",
            extra={
                "model": request.model or settings.groq_model,
                "has_sql": bool(sql),
                "row_count": len(rows),
                "execution_time": execution_time,
            },
        )

        return SQLAgentResponse(
            answer=answer,
            sql=sql,
            rows=rows,
            execution_time=execution_time,
            trace_id=get_trace_id(),
        )

    async def stream(self, request: SQLAgentRequest) -> AsyncIterator[SQLAgentStreamEvent]:
        callback = StreamingEventCallback()
        task = asyncio.create_task(self._run_streaming_agent(request, callback))

        yield self._event("start", {"message": "SQL agent started"})

        async for item in callback.events():
            yield self._event(str(item.pop("event")), item)

        try:
            response = await task
        except AppError as exc:
            yield self._event(
                "error",
                {
                    "error_code": exc.error_code,
                    "message": exc.message,
                    "details": exc.details,
                },
            )
        except Exception as exc:
            logger.exception("SQL agent stream failed")
            yield self._event(
                "error",
                {
                    "error_code": "sql_agent_stream_failed",
                    "message": exc.__class__.__name__,
                },
            )
        else:
            yield self._event("final", response.model_dump())

    async def _run_streaming_agent(
        self, request: SQLAgentRequest, callback: StreamingEventCallback
    ) -> SQLAgentResponse:
        try:
            response = await self.run_with_callback(request, callback)
        finally:
            callback.done()
        return response

    async def run_with_callback(
        self, request: SQLAgentRequest, callback: StreamingEventCallback
    ) -> SQLAgentResponse:
        started_at = time.perf_counter()
        payload = await self._run_with_retries(request, callbacks=[callback])
        sql = self._extract_sql(payload)
        rows = (
            await self._execute_sql(sql, limit=request.top_k or settings.sql_agent_top_k)
            if sql
            else []
        )
        return SQLAgentResponse(
            answer=str(payload.get("output", "")),
            sql=sql,
            rows=rows,
            execution_time=round(time.perf_counter() - started_at, 4),
            trace_id=get_trace_id(),
        )

    async def _run_with_retries(
        self,
        request: SQLAgentRequest,
        callbacks: list[StreamingEventCallback] | None = None,
    ) -> dict[str, Any]:
        attempts = max(settings.groq_max_retries + 1, 1)
        last_error: Exception | None = None
        for attempt in range(1, attempts + 1):
            try:
                return await asyncio.to_thread(self._invoke_agent, request, callbacks)
            except AppError:
                raise
            except Exception as exc:
                last_error = exc
                logger.warning(
                    "SQL agent attempt failed",
                    extra={
                        "attempt": attempt,
                        "max_attempts": attempts,
                        "error": exc.__class__.__name__,
                    },
                )
                if attempt < attempts:
                    await asyncio.sleep(min(2**attempt, 6))

        raise ServiceUnavailableError("SQL agent failed after retry attempts.") from last_error

    def _invoke_agent(
        self,
        request: SQLAgentRequest,
        callbacks: list[StreamingEventCallback] | None,
    ) -> dict[str, Any]:
        if not settings.groq_api_key:
            raise AppError(
                "GROQ_API_KEY is not configured.",
                status_code=503,
                error_code="groq_api_key_missing",
            )

        model = request.model or settings.groq_model
        llm = ChatGroq(
            api_key=settings.groq_api_key,
            model=model,
            temperature=settings.groq_temperature,
            streaming=settings.sql_agent_streaming,
            callbacks=callbacks,
        )
        toolkit = SQLDatabaseToolkit(db=self.tool_router.database, llm=llm)
        agent_executor = create_sql_agent(
            llm=llm,
            toolkit=toolkit,
            agent_type=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
            prefix=SQL_AGENT_PREFIX,
            suffix=SQL_AGENT_SUFFIX,
            top_k=request.top_k or settings.sql_agent_top_k,
            max_iterations=settings.sql_agent_max_iterations,
            max_execution_time=settings.sql_agent_max_execution_time,
            verbose=settings.is_development,
            agent_executor_kwargs={
                "return_intermediate_steps": True,
                "handle_parsing_errors": True,
                "callbacks": callbacks,
            },
        )
        return agent_executor.invoke({"input": self._build_question(request)})

    def _build_question(self, request: SQLAgentRequest) -> str:
        memory = "\n".join(
            f"{item.get('role', 'unknown')}: {item.get('content', '')}"
            for item in request.memory[-8:]
        )
        if not memory:
            return request.question
        return f"Conversation context:\n{memory}\n\nCurrent question:\n{request.question}"

    def _extract_sql(self, payload: dict[str, Any]) -> str | None:
        candidates: list[str] = []
        for action, _observation in payload.get("intermediate_steps", []):
            tool_name = getattr(action, "tool", "")
            tool_input = getattr(action, "tool_input", "")
            if tool_name in {"sql_db_query", "sql_db_query_checker"}:
                candidates.append(self._coerce_tool_input(tool_input))

        for candidate in reversed(candidates):
            try:
                return self.tool_router.validate_read_only_sql(candidate)
            except SQLValidationError:
                continue
        return None

    def _coerce_tool_input(self, tool_input: Any) -> str:
        if isinstance(tool_input, str):
            return tool_input
        if isinstance(tool_input, dict):
            return str(tool_input.get("query") or tool_input.get("sql") or "")
        return str(tool_input)

    async def _execute_sql(self, sql: str, *, limit: int) -> list[dict[str, object]]:
        result = await asyncio.to_thread(self.tool_router.execute_read_only, sql, limit=limit)
        return json.loads(json.dumps(result.rows, default=str))

    def _event(self, event: str, data: dict[str, object]) -> SQLAgentStreamEvent:
        return SQLAgentStreamEvent(event=event, data=data, trace_id=get_trace_id())


def get_sql_agent_service() -> SQLAgentService:
    return SQLAgentService()
