from contextvars import ContextVar
from uuid import uuid4

trace_id_ctx: ContextVar[str] = ContextVar("trace_id", default="-")


def get_trace_id() -> str:
    return trace_id_ctx.get()


def set_trace_id(trace_id: str | None = None) -> str:
    value = trace_id or str(uuid4())
    trace_id_ctx.set(value)
    return value

