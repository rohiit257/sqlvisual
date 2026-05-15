import { Activity, Database, Sparkles } from "lucide-react";

import { ChatPanel } from "@/components/dashboard/chat-panel";
import { Sidebar } from "@/components/dashboard/sidebar";
import { Button } from "@/components/ui/button";

const metrics = [
  { label: "Connected sources", value: "03" },
  { label: "Queries drafted", value: "128" },
  { label: "Review queue", value: "07" }
];

export default function DashboardPage() {
  return (
    <main className="dashboard-grid min-h-screen overflow-hidden">
      <div className="mx-auto flex min-h-screen w-full max-w-7xl gap-4 p-4 lg:p-6">
        <Sidebar />

        <section className="flex min-w-0 flex-1 flex-col rounded-[2rem] border border-white/10 bg-slate-950/65 shadow-2xl shadow-cyan-950/30 backdrop-blur-xl">
          <header className="flex flex-col gap-5 border-b border-white/10 p-6 lg:flex-row lg:items-center lg:justify-between">
            <div>
              <div className="mb-3 inline-flex items-center gap-2 rounded-full border border-cyan-300/20 bg-cyan-300/10 px-3 py-1 text-xs text-cyan-100">
                <Sparkles className="h-3.5 w-3.5" />
                AI SQL analytics cockpit
              </div>
              <h1 className="text-3xl font-semibold tracking-tight text-white md:text-4xl">
                Ask business questions. Ship trusted SQL.
              </h1>
              <p className="mt-3 max-w-2xl text-sm leading-6 text-slate-300">
                A focused workspace for translating natural language into reviewed SQL,
                explainable insights, and reusable analytics workflows.
              </p>
            </div>

            <Button className="w-full bg-cyan-300 text-slate-950 hover:bg-cyan-200 lg:w-auto">
              New analysis
            </Button>
          </header>

          <div className="grid flex-1 gap-4 p-4 lg:grid-cols-[1fr_22rem] lg:p-6">
            <ChatPanel />

            <aside className="space-y-4">
              <div className="rounded-3xl border border-white/10 bg-white/[0.04] p-5">
                <div className="mb-4 flex items-center gap-2 text-sm font-medium text-slate-200">
                  <Activity className="h-4 w-4 text-cyan-300" />
                  Workspace pulse
                </div>
                <div className="grid gap-3">
                  {metrics.map((metric) => (
                    <div
                      key={metric.label}
                      className="flex items-center justify-between rounded-2xl bg-slate-900/70 px-4 py-3"
                    >
                      <span className="text-sm text-slate-400">{metric.label}</span>
                      <span className="text-lg font-semibold text-white">{metric.value}</span>
                    </div>
                  ))}
                </div>
              </div>

              <div className="rounded-3xl border border-white/10 bg-white/[0.04] p-5">
                <div className="mb-3 flex items-center gap-2 text-sm font-medium text-slate-200">
                  <Database className="h-4 w-4 text-cyan-300" />
                  Data context
                </div>
                <p className="text-sm leading-6 text-slate-400">
                  Connect warehouse metadata here later so the assistant can reason about
                  schemas, joins, definitions, and row-level safety.
                </p>
              </div>
            </aside>
          </div>
        </section>
      </div>
    </main>
  );
}
