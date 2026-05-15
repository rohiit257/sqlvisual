import re
from dataclasses import dataclass
from functools import lru_cache

from langchain_community.utilities.sql_database import SQLDatabase
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine

from app.core.config import settings

READ_ONLY_PATTERN = re.compile(r"^\s*(select|with|explain)\b", re.IGNORECASE | re.DOTALL)
FORBIDDEN_PATTERN = re.compile(
    r"\b(insert|update|delete|drop|alter|truncate|create|grant|revoke|copy|call|do|merge)\b",
    re.IGNORECASE,
)


class SQLValidationError(ValueError):
    pass


@dataclass(frozen=True)
class SQLExecutionResult:
    sql: str
    rows: list[dict[str, object]]


class SQLToolRouter:
    """Small abstraction layer around SQL inspection, validation, and execution."""

    def __init__(self) -> None:
        self._engine = create_engine(
            settings.sync_database_url,
            pool_pre_ping=True,
            pool_size=settings.database_pool_size,
            max_overflow=settings.database_max_overflow,
            pool_timeout=settings.database_pool_timeout,
            pool_recycle=settings.database_pool_recycle,
        )
        self._database = SQLDatabase(
            engine=self._engine,
            schema=settings.sql_agent_schema,
            include_tables=settings.sql_agent_tables,
            sample_rows_in_table_info=settings.sql_agent_sample_rows,
            indexes_in_table_info=True,
            view_support=True,
            lazy_table_reflection=True,
        )

    @property
    def database(self) -> SQLDatabase:
        return self._database

    @property
    def engine(self) -> Engine:
        return self._engine

    def inspect_schema(self) -> str:
        return self._database.get_table_info()

    def validate_read_only_sql(self, sql: str) -> str:
        normalized = sql.strip().rstrip(";")
        if not normalized:
            raise SQLValidationError("No SQL statement was generated.")
        if not READ_ONLY_PATTERN.match(normalized):
            raise SQLValidationError("Only read-only SELECT, WITH, or EXPLAIN queries are allowed.")
        if FORBIDDEN_PATTERN.search(normalized):
            raise SQLValidationError("The generated SQL contains a forbidden statement.")
        return normalized

    def execute_read_only(self, sql: str, *, limit: int) -> SQLExecutionResult:
        validated_sql = self.validate_read_only_sql(sql)
        limited_sql = self._apply_limit(validated_sql, limit)

        with self._engine.connect() as connection:
            result = connection.execute(text(limited_sql))
            rows = [dict(row._mapping) for row in result.fetchall()]

        return SQLExecutionResult(sql=limited_sql, rows=rows)

    def dispose(self) -> None:
        self._engine.dispose()

    def _apply_limit(self, sql: str, limit: int) -> str:
        if re.search(r"\blimit\s+\d+\b", sql, re.IGNORECASE):
            return sql
        return f"SELECT * FROM ({sql}) AS sqlvisual_limited_result LIMIT {limit}"


@lru_cache
def get_sql_tool_router() -> SQLToolRouter:
    return SQLToolRouter()
