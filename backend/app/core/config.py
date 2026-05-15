from functools import lru_cache
from typing import Literal

from pydantic import Field, computed_field, model_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

Environment = Literal["development", "test", "staging", "production"]


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=("../.env", ".env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    environment: Environment = "development"
    project_name: str = "SQL Visual"
    version: str = "0.1.0"
    log_level: str = "info"
    json_logs: bool = True

    api_v1_prefix: str = "/api/v1"
    backend_host: str = "0.0.0.0"
    backend_port: int = 8000
    backend_cors_origins: str = Field(default="http://localhost:3000")

    database_url: str = "postgresql+asyncpg://sqlvisual:sqlvisual_password@postgres:5432/sqlvisual"
    database_echo: bool = False
    database_pool_size: int = 10
    database_max_overflow: int = 20
    database_pool_timeout: int = 30
    database_pool_recycle: int = 1800
    redis_url: str = "redis://redis:6379/0"
    redis_socket_timeout: float = 5.0
    redis_health_check_interval: int = 30
    redis_fail_fast: bool = False

    request_trace_header: str = "x-request-id"
    request_timeout_seconds: int = 60

    @computed_field
    @property
    def cors_origins(self) -> list[str]:
        return [origin.strip() for origin in self.backend_cors_origins.split(",") if origin.strip()]

    @computed_field
    @property
    def is_development(self) -> bool:
        return self.environment == "development"

    @computed_field
    @property
    def is_production(self) -> bool:
        return self.environment == "production"

    @model_validator(mode="after")
    def enforce_production_safety(self) -> "Settings":
        if self.is_production and "*" in self.cors_origins:
            msg = "Wildcard CORS origins are not allowed in production."
            raise ValueError(msg)
        return self


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
