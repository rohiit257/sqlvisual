from pydantic import BaseModel, Field


class ErrorResponse(BaseModel):
    error_code: str
    message: str
    trace_id: str
    details: dict[str, object] = Field(default_factory=dict)

