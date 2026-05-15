from typing import Literal

from pydantic import BaseModel, Field

GroqModel = Literal["llama-3.3-70b-versatile", "deepseek-r1-distill-llama-70b"]


class SQLAgentRequest(BaseModel):
    question: str = Field(min_length=3, max_length=2000)
    model: GroqModel | None = None
    conversation_id: str | None = Field(default=None, max_length=128)
    memory: list[dict[str, str]] = Field(default_factory=list)
    top_k: int | None = Field(default=None, ge=1, le=100)
    stream: bool = False


class SQLAgentResponse(BaseModel):
    answer: str
    sql: str | None = None
    rows: list[dict[str, object]] = Field(default_factory=list)
    execution_time: float
    trace_id: str


class SQLAgentStreamEvent(BaseModel):
    event: str
    data: dict[str, object]
    trace_id: str

