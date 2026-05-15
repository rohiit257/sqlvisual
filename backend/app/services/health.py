import time
from collections.abc import Awaitable, Callable

from app.db.redis import redis_manager
from app.db.session import check_database_connection
from app.schemas.health import DependencyHealth, ReadinessResponse


class HealthService:
    async def readiness(self) -> ReadinessResponse:
        dependencies = {
            "postgres": await self._check("postgres", check_database_connection),
            "redis": await self._check("redis", redis_manager.ping),
        }
        status = "ok" if all(item.status == "ok" for item in dependencies.values()) else "degraded"
        return ReadinessResponse(status=status, dependencies=dependencies)

    async def _check(
        self,
        _: str,
        check: Callable[[], Awaitable[object]],
    ) -> DependencyHealth:
        started_at = time.perf_counter()
        try:
            await check()
        except Exception as exc:
            return DependencyHealth(
                status="error",
                latency_ms=round((time.perf_counter() - started_at) * 1000, 2),
                error=exc.__class__.__name__,
            )

        return DependencyHealth(
            status="ok",
            latency_ms=round((time.perf_counter() - started_at) * 1000, 2),
        )


def get_health_service() -> HealthService:
    return HealthService()

