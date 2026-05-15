"use client";

import { ChatPanel } from "@/components/dashboard/chat-panel";
import { DashboardHeader } from "@/components/dashboard/dashboard-header";
import { Sidebar } from "@/components/dashboard/sidebar";
import { SqlPreviewPanel } from "@/components/dashboard/sql-preview-panel";

export default function DashboardPage() {
  return (
    <main className="dashboard-grid min-h-screen overflow-hidden text-slate-100">
      <div className="pointer-events-none fixed inset-0 opacity-80">
        <div className="absolute left-1/2 top-0 h-72 w-72 -translate-x-1/2 rounded-full bg-cyan-300/20 blur-3xl" />
        <div className="absolute bottom-10 right-10 h-80 w-80 rounded-full bg-emerald-400/10 blur-3xl" />
      </div>

      <div className="relative mx-auto flex min-h-screen w-full max-w-[1540px] gap-4 p-3 sm:p-4 lg:p-6">
        <Sidebar />

        <section className="flex min-w-0 flex-1 flex-col rounded-[2rem] border border-white/10 bg-slate-950/70 shadow-2xl shadow-cyan-950/30 backdrop-blur-2xl">
          <DashboardHeader />

          <div className="grid min-h-0 flex-1 gap-4 p-3 sm:p-4 xl:grid-cols-[minmax(0,1fr)_27rem] xl:p-5">
            <ChatPanel />
            <SqlPreviewPanel />
          </div>
        </section>
      </div>
    </main>
  );
}
