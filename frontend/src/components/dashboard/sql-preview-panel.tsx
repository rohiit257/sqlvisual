"use client";

import { motion } from "framer-motion";
import { CheckCircle2, Clipboard, Database, Play, ShieldCheck, WandSparkles } from "lucide-react";

import { Button } from "@/components/ui/button";

const sql = `SELECT
  sales_month,
  category_name,
  SUM(net_revenue) AS net_revenue
FROM analytics.monthly_sales_summary
GROUP BY sales_month, category_name
ORDER BY sales_month, net_revenue DESC;`;

const checks = ["Read-only query", "Uses semantic view", "No sensitive columns"];

export function SqlPreviewPanel() {
  return (
    <motion.aside
      initial={{ opacity: 0, x: 18 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ duration: 0.5, ease: "easeOut" }}
      className="grid gap-4 xl:grid-rows-[auto_auto_1fr]"
    >
      <section className="rounded-[1.75rem] border border-white/10 bg-white/[0.045] p-4 shadow-2xl shadow-slate-950/30 backdrop-blur">
        <div className="mb-4 flex items-center justify-between">
          <div>
            <div className="flex items-center gap-2 text-sm font-medium text-slate-100">
              <WandSparkles className="h-4 w-4 text-cyan-300" />
              SQL preview
            </div>
            <p className="mt-1 text-xs text-slate-500">Generated draft, ready for review.</p>
          </div>
          <span className="rounded-full border border-amber-300/20 bg-amber-300/10 px-3 py-1 text-xs text-amber-100">
            Draft
          </span>
        </div>

        <div className="overflow-hidden rounded-2xl border border-white/10 bg-[#050914]">
          <div className="flex items-center justify-between border-b border-white/10 px-4 py-2">
            <div className="flex gap-1.5">
              <span className="h-2.5 w-2.5 rounded-full bg-rose-400/80" />
              <span className="h-2.5 w-2.5 rounded-full bg-amber-300/80" />
              <span className="h-2.5 w-2.5 rounded-full bg-emerald-300/80" />
            </div>
            <button className="flex items-center gap-1.5 text-xs text-slate-500 transition hover:text-slate-200">
              <Clipboard className="h-3.5 w-3.5" />
              Copy
            </button>
          </div>
          <pre className="scrollbar-premium overflow-x-auto p-4 text-[12px] leading-6 text-cyan-50">
            <code>{sql}</code>
          </pre>
        </div>

        <div className="mt-4 grid grid-cols-2 gap-2">
          <Button className="bg-cyan-300 text-slate-950 hover:bg-cyan-200">
            <Play className="h-4 w-4" />
            Run query
          </Button>
          <Button
            variant="secondary"
            className="border border-white/10 bg-white/[0.06] text-slate-200 hover:bg-white/10"
          >
            Explain SQL
          </Button>
        </div>
      </section>

      <section className="rounded-[1.75rem] border border-white/10 bg-white/[0.04] p-4">
        <div className="mb-3 flex items-center gap-2 text-sm font-medium text-slate-100">
          <ShieldCheck className="h-4 w-4 text-emerald-300" />
          Guardrail checks
        </div>
        <div className="space-y-2">
          {checks.map((check) => (
            <div
              key={check}
              className="flex items-center justify-between rounded-2xl bg-slate-950/60 px-3 py-2"
            >
              <span className="text-sm text-slate-400">{check}</span>
              <CheckCircle2 className="h-4 w-4 text-emerald-300" />
            </div>
          ))}
        </div>
      </section>

      <section className="rounded-[1.75rem] border border-white/10 bg-white/[0.04] p-4">
        <div className="mb-4 flex items-center gap-2 text-sm font-medium text-slate-100">
          <Database className="h-4 w-4 text-cyan-300" />
          Result shape
        </div>
        <div className="grid grid-cols-3 gap-2">
          {[
            { label: "Rows", value: "30" },
            { label: "Columns", value: "3" },
            { label: "Cost", value: "Low" }
          ].map((item) => (
            <div key={item.label} className="rounded-2xl bg-slate-950/65 p-3">
              <p className="text-[10px] uppercase tracking-[0.18em] text-slate-600">
                {item.label}
              </p>
              <p className="mt-2 text-lg font-semibold text-white">{item.value}</p>
            </div>
          ))}
        </div>
        <div className="mt-4 rounded-2xl border border-cyan-300/10 bg-cyan-300/[0.04] p-3 text-sm leading-6 text-slate-400">
          The query reads from the monthly summary materialized view, keeping execution fast and
          predictable for dashboard workloads.
        </div>
      </section>
    </motion.aside>
  );
}
