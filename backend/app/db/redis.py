import logging

from redis.asyncio import Redis, from_url

from app.core.config import settings

logger = logging.getLogger(__name__)


class RedisManager:
    def __init__(self) -> None:
        self._client: Redis | None = None

    async def connect(self) -> None:
        if self._client is not None:
            return

        self._client = from_url(
            settings.redis_url,
            encoding="utf-8",
            decode_responses=True,
            socket_timeout=settings.redis_socket_timeout,
            health_check_interval=settings.redis_health_check_interval,
        )
        try:
            await self.ping()
        except Exception:
            logger.exception("Redis connection check failed")
            if settings.redis_fail_fast:
                raise
        else:
            logger.info("Redis connection established")

    async def disconnect(self) -> None:
        if self._client is None:
            return

        await self._client.aclose()
        self._client = None
        logger.info("Redis connection closed")

    async def ping(self) -> bool:
        client = self.client
        return bool(await client.ping())

    @property
    def client(self) -> Redis:
        if self._client is None:
            msg = "Redis client has not been initialized."
            raise RuntimeError(msg)
        return self._client


redis_manager = RedisManager()


async def get_redis_client() -> Redis:
    return redis_manager.client
