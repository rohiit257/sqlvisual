import asyncio
from collections.abc import AsyncIterator
from typing import Any

from langchain.callbacks.base import BaseCallbackHandler


class StreamingEventCallback(BaseCallbackHandler):
    def __init__(self) -> None:
        self.loop = asyncio.get_running_loop()
        self.queue: asyncio.Queue[dict[str, object] | None] = asyncio.Queue()

    def on_llm_new_token(self, token: str, **_: Any) -> None:
        self._emit({"event": "token", "token": token})

    def on_agent_action(self, action: Any, **_: Any) -> None:
        self._emit(
            {
                "event": "tool_start",
                "tool": getattr(action, "tool", "unknown"),
                "tool_input": str(getattr(action, "tool_input", ""))[:1000],
            }
        )

    def on_tool_end(self, output: str, **_: Any) -> None:
        self._emit({"event": "tool_end", "output": str(output)[:2000]})

    def done(self) -> None:
        self.loop.call_soon_threadsafe(self.queue.put_nowait, None)

    async def events(self) -> AsyncIterator[dict[str, object]]:
        while True:
            item = await self.queue.get()
            if item is None:
                break
            yield item

    def _emit(self, item: dict[str, object]) -> None:
        self.loop.call_soon_threadsafe(self.queue.put_nowait, item)
