from collections.abc import AsyncIterator

from fastapi import Depends
from redis.asyncio import Redis
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.redis import get_redis_client
from app.db.session import get_db_session


async def get_session() -> AsyncIterator[AsyncSession]:
    async for session in get_db_session():
        yield session


async def get_cache() -> Redis:
    return await get_redis_client()


DatabaseSession = Depends(get_session)
CacheClient = Depends(get_cache)
