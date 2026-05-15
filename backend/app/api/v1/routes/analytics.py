import json
from typing import Annotated

from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse

from app.schemas.agent import SQLAgentRequest, SQLAgentResponse
from app.services.agents import SQLAgentService, get_sql_agent_service

router = APIRouter()


@router.post("/query", response_model=SQLAgentResponse)
async def query_agent(
    request: SQLAgentRequest,
    agent_service: Annotated[SQLAgentService, Depends(get_sql_agent_service)],
) -> SQLAgentResponse:
    return await agent_service.run(request)


@router.post("/query/stream")
async def stream_query_agent(
    request: SQLAgentRequest,
    agent_service: Annotated[SQLAgentService, Depends(get_sql_agent_service)],
) -> StreamingResponse:
    async def event_stream():
        async for event in agent_service.stream(request):
            yield f"event: {event.event}\ndata: {json.dumps(event.model_dump(), default=str)}\n\n"

    return StreamingResponse(event_stream(), media_type="text/event-stream")
