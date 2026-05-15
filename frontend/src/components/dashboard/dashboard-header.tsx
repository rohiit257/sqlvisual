"use client";

import { motion } from "framer-motion";
import { Cable, ChevronDown, CircleCheck, Database, Sparkles } from "lucide-react";

import { Button } from "@/components/ui/button";

const stats = [
  { label: "Northwind", value: "Postgres 16" },
  { label: "Latency", value: "42 ms" },
  { label: "Context", value: "19 columns" }
];

export function DashboardHeader() {
  return (
    <header className="border-b border-white/10 px-4 py-4 sm:px-6">
      <div className="flex flex-col gap-5 xl:flex-row xl:items-center xl:justify-between">
        <motion.div
          initial={{ opacity: 0, y: -8 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.45, ease: "easeOut" }}
          className="min-w-0"
        >
          <div className="mb-3 inline-flex items-center gap-2 rounded-full border border-cyan-300/20 bg-cyan-300/10 px-3 py-1 text-xs text-cyan-100 shadow-lg shadow-cyan-950/20">
            <Sparkles className="h-3.5 w-3.5" />
            SQL Visual intelligence layer
          </div>
          <div className="flex flex-col gap-3 lg:flex-row lg:items-end lg:justify-between">
            <div>
              <h1 className="text-balance text-2xl font-semibold tracking-tight text-white sm:text-3xl">
                Ask, inspect, and ship trusted SQL.
              </h1>
              <p className="mt-2 max-w-3xl text-sm leading-6 text-slate-400">
                A premium AI analytics cockpit for natural language exploration,
                schema-aware generation, and reviewable SQL execution.
              </p>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, x: 12 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.45, delay: 0.1, ease: "easeOut" }}
          className="flex flex-col gap-3 sm:flex-row sm:items-center"
        >
          <div className="grid grid-cols-3 gap-2 rounded-2xl border border-white/10 bg-white/[0.04] p-2">
            {stats.map((stat) => (
              <div key={stat.label} className="rounded-xl bg-slate-950/60 px-3 py-2">
                <p className="text-[10px] uppercase tracking-[0.18em] text-slate-500">
                  {stat.label}
                </p>
                <p className="mt-1 whitespace-nowrap text-xs font-medium text-slate-100">
                  {stat.value}
                </p>
              </div>
            ))}
          </div>

          <Button
            variant="secondary"
            className="h-12 justify-between border border-emerald-300/20 bg-emerald-300/10 text-emerald-100 hover:bg-emerald-300/15"
          >
            <span className="flex items-center gap-2">
              <span className="relative flex h-2.5 w-2.5">
                <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-emerald-300 opacity-60" />
                <span className="relative inline-flex h-2.5 w-2.5 rounded-full bg-emerald-300" />
              </span>
              Connected
            </span>
            <ChevronDown className="h-4 w-4 opacity-70" />
          </Button>
        </motion.div>
      </div>

      <div className="mt-4 grid gap-3 md:grid-cols-3">
        {[
          { icon: Database, label: "Warehouse", value: "Northwind analytics" },
          { icon: Cable, label: "API", value: "FastAPI ready" },
          { icon: CircleCheck, label: "Guardrails", value: "Review before run" }
        ].map((item, index) => {
          const Icon = item.icon;

          return (
            <motion.div
              key={item.label}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.12 + index * 0.06, duration: 0.4 }}
              className="rounded-2xl border border-white/10 bg-white/[0.035] px-4 py-3"
            >
              <div className="flex items-center gap-3">
                <div className="grid h-9 w-9 place-items-center rounded-xl bg-cyan-300/10 text-cyan-200">
                  <Icon className="h-4 w-4" />
                </div>
                <div>
                  <p className="text-xs text-slate-500">{item.label}</p>
                  <p className="text-sm font-medium text-slate-200">{item.value}</p>
                </div>
              </div>
            </motion.div>
          );
        })}
      </div>
    </header>
  );
}
