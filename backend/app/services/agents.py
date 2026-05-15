class AgentService:
    """Future orchestration seam for LangChain agents and tools."""

    async def run(self, prompt: str) -> str:
        raise NotImplementedError("LangChain agent integration is not wired yet.")


def get_agent_service() -> AgentService:
    return AgentService()

