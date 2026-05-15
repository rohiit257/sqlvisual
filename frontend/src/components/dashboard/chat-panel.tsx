import { Bot, Send, UserRound } from "lucide-react";

import { Button } from "@/components/ui/button";

const messages = [
  {
    role: "assistant",
    content:
      "Tell me what metric you want to analyze, and I will draft SQL with assumptions called out before execution."
  },
  {
    role: "user",
    content: "Show weekly revenue by acquisition channel for the last quarter."
  }
];

export function ChatPanel() {
  return (
    <section className="flex min-h-[34rem] flex-col rounded-3xl border border-white/10 bg-slate-950/70">
      <div className="border-b border-white/10 p-5">
        <div className="flex items-center gap-2 text-sm font-medium text-slate-200">
          <Bot className="h-4 w-4 text-cyan-300" />
          Analyst chat
        </div>
        <p className="mt-2 text-sm text-slate-400">
          Placeholder UI for the future LangChain-powered SQL assistant.
        </p>
      </div>

      <div className="flex-1 space-y-4 p-5">
        {messages.map((message) => {
          const isUser = message.role === "user";

          return (
            <div
              key={message.content}
              className={`flex gap-3 ${isUser ? "justify-end" : "justify-start"}`}
            >
              {!isUser && (
                <div className="grid h-9 w-9 place-items-center rounded-2xl bg-cyan-300/15 text-cyan-200">
                  <Bot className="h-4 w-4" />
                </div>
              )}
              <div
                className={`max-w-[78%] rounded-3xl px-4 py-3 text-sm leading-6 ${
                  isUser
                    ? "bg-cyan-300 text-slate-950"
                    : "border border-white/10 bg-white/[0.05] text-slate-200"
                }`}
              >
                {message.content}
              </div>
              {isUser && (
                <div className="grid h-9 w-9 place-items-center rounded-2xl bg-white/10 text-slate-200">
                  <UserRound className="h-4 w-4" />
                </div>
              )}
            </div>
          );
        })}
      </div>

      <div className="border-t border-white/10 p-4">
        <div className="flex items-center gap-3 rounded-2xl border border-white/10 bg-slate-900/80 p-2">
          <input
            className="min-w-0 flex-1 bg-transparent px-3 text-sm text-slate-100 outline-none placeholder:text-slate-500"
            placeholder="Ask for a metric, cohort, or SQL transformation..."
          />
          <Button size="icon" className="bg-cyan-300 text-slate-950 hover:bg-cyan-200">
            <Send className="h-4 w-4" />
          </Button>
        </div>
      </div>
    </section>
  );
}

