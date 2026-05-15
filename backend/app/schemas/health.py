from pydantic import BaseModel


class HealthResponse(BaseModel):
    status: str


class DependencyHealth(BaseModel):
    status: str
    latency_ms: float | None = None
    error: str | None = None


class ReadinessResponse(BaseModel):
    status: str
    dependencies: dict[str, DependencyHealth]
