"use client";

import { motion } from "framer-motion";
import { Bot, CornerDownLeft, Loader2, Paperclip, Send, Sparkles, UserRound } from "lucide-react";

import { Button } from "@/components/ui/button";

const messages = [
  {
    role: "assistant",
    label: "SQL Visual",
    content:
      "I scanned the Northwind metadata and found revenue-ready joins across orders, order_details, products, categories, and customers."
  },
  {
    role: "user",
    label: "You",
    content: "Which product categories drove the most revenue by month?"
  },
  {
    role: "assistant",
    label: "SQL Visual",
    streaming: true,
    content:
      "I can answer that with the materialized monthly_sales_summary. I will group by sales_month and category_name, then rank categories by net revenue so the SQL stays reviewable before execution."
  }
];

const suggestions = ["Revenue by country", "Late shipments", "Inventory risk"];

export function ChatPanel() {
  return (
    <section className="flex min-h-[36rem] min-w-0 flex-col overflow-hidden rounded-[1.75rem] border border-white/10 bg-slate-950/80 shadow-2xl shadow-slate-950/40">
      <div className="flex items-center justify-between border-b border-white/10 px-4 py-4 sm:px-5">
        <div>
          <div className="flex items-center gap-2 text-sm font-medium text-slate-100">
            <span className="grid h-8 w-8 place-items-center rounded-xl bg-cyan-300/10 text-cyan-200">
              <Bot className="h-4 w-4" />
            </span>
            Analyst chat
          </div>
          <p className="mt-1 text-xs text-slate-500">
            Streaming-ready renderer with reviewable SQL handoff.
          </p>
        </div>
        <div className="hidden items-center gap-2 rounded-full border border-white/10 bg-white/[0.04] px-3 py-1.5 text-xs text-slate-400 sm:flex">
          <Loader2 className="h-3.5 w-3.5 animate-spin text-cyan-300" />
          Thinking
        </div>
      </div>

      <div className="scrollbar-premium flex-1 space-y-5 overflow-y-auto p-4 sm:p-6">
        {messages.map((message, index) => {
          const isUser = message.role === "user";

          return (
            <motion.div
              key={message.content}
              initial={{ opacity: 0, y: 12, scale: 0.98 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              transition={{ duration: 0.35, delay: index * 0.08, ease: "easeOut" }}
              className={`flex gap-3 ${isUser ? "justify-end" : "justify-start"}`}
            >
              {!isUser && (
                <div className="mt-1 grid h-9 w-9 shrink-0 place-items-center rounded-2xl bg-gradient-to-br from-cyan-300/20 to-emerald-300/10 text-cyan-100 ring-1 ring-cyan-200/15">
                  <Sparkles className="h-4 w-4" />
                </div>
              )}

              <div className={`max-w-[86%] space-y-2 ${isUser ? "items-end" : "items-start"}`}>
                <div
                  className={`flex items-center gap-2 text-xs ${
                    isUser ? "justify-end text-cyan-100/80" : "text-slate-500"
                  }`}
                >
                  <span>{message.label}</span>
                  {message.streaming && (
                    <span className="rounded-full bg-cyan-300/10 px-2 py-0.5 text-cyan-200">
                      streaming
                    </span>
                  )}
                </div>

                <div
                  className={`rounded-[1.35rem] px-4 py-3 text-sm leading-6 shadow-lg ${
                    isUser
                      ? "bg-cyan-300 text-slate-950 shadow-cyan-950/20"
                      : "border border-white/10 bg-white/[0.055] text-slate-200 shadow-slate-950/30"
                  }`}
                >
                  <StreamingText text={message.content} streaming={message.streaming} />
                </div>
              </div>

              {isUser && (
                <div className="mt-1 grid h-9 w-9 shrink-0 place-items-center rounded-2xl bg-white/10 text-slate-200 ring-1 ring-white/10">
                  <UserRound className="h-4 w-4" />
                </div>
              )}
            </motion.div>
          );
        })}
      </div>

      <div className="border-t border-white/10 bg-slate-950/80 p-3 sm:p-4">
        <div className="mb-3 flex flex-wrap gap-2">
          {suggestions.map((suggestion) => (
            <button
              key={suggestion}
              className="rounded-full border border-white/10 bg-white/[0.04] px-3 py-1.5 text-xs text-slate-400 transition hover:border-cyan-300/30 hover:text-cyan-100"
            >
              {suggestion}
            </button>
          ))}
        </div>

        <div className="rounded-[1.5rem] border border-white/10 bg-slate-900/90 p-2 shadow-inner shadow-black/30">
          <div className="flex items-end gap-2">
            <Button
              variant="ghost"
              size="icon"
              className="mb-1 shrink-0 text-slate-500 hover:bg-white/10 hover:text-slate-200"
            >
              <Paperclip className="h-4 w-4" />
            </Button>
            <textarea
              rows={2}
              className="max-h-36 min-h-12 flex-1 resize-none bg-transparent px-2 py-3 text-sm leading-6 text-slate-100 outline-none placeholder:text-slate-600"
              placeholder="Ask about revenue, customers, products, cohorts, anomalies..."
            />
            <Button size="icon" className="mb-1 shrink-0 bg-cyan-300 text-slate-950 hover:bg-cyan-200">
              <Send className="h-4 w-4" />
            </Button>
          </div>
          <div className="flex items-center justify-between px-3 pb-2 pt-1 text-[11px] text-slate-600">
            <span>Schema-aware SQL generation</span>
            <span className="hidden items-center gap-1 sm:flex">
              <CornerDownLeft className="h-3 w-3" />
              Enter to send
            </span>
          </div>
        </div>
      </div>
    </section>
  );
}

function StreamingText({ text, streaming }: { text: string; streaming?: boolean }) {
  return (
    <span>
      {text}
      {streaming && (
        <motion.span
          className="ml-1 inline-block h-4 w-1.5 translate-y-0.5 rounded-full bg-cyan-200"
          animate={{ opacity: [0.2, 1, 0.2] }}
          transition={{ duration: 1, repeat: Infinity }}
        />
      )}
    </span>
  );
}
