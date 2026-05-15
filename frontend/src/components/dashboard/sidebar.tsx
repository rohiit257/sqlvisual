"use client";

import { motion } from "framer-motion";
import {
  BarChart3,
  Blocks,
  Braces,
  DatabaseZap,
  LayoutDashboard,
  Search,
  Settings2,
  Table2
} from "lucide-react";

const navigation = [
  { label: "Dashboard", icon: LayoutDashboard, active: true },
  { label: "Schema", icon: DatabaseZap },
  { label: "Analyses", icon: BarChart3 },
  { label: "Workflows", icon: Blocks },
  { label: "Settings", icon: Settings2 }
];

const schemaTables = [
  { name: "orders", columns: 11, hot: true },
  { name: "order_details", columns: 5, hot: true },
  { name: "products", columns: 10 },
  { name: "customers", columns: 9 },
  { name: "schema_metadata", columns: 9 }
];

export function Sidebar() {
  return (
    <motion.aside
      initial={{ opacity: 0, x: -18 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ duration: 0.5, ease: "easeOut" }}
      className="hidden w-72 shrink-0 rounded-[2rem] border border-white/10 bg-slate-950/75 p-4 shadow-2xl shadow-cyan-950/20 backdrop-blur-2xl lg:flex lg:flex-col"
    >
      <div className="mb-6 flex items-center gap-3 px-2 pt-2">
        <div className="grid h-11 w-11 place-items-center rounded-2xl bg-gradient-to-br from-cyan-200 to-emerald-300 text-lg font-black text-slate-950 shadow-lg shadow-cyan-950/30">
          SV
        </div>
        <div>
          <p className="font-semibold text-white">SQL Visual</p>
          <p className="text-xs text-slate-500">AI analytics studio</p>
        </div>
      </div>

      <div className="mb-4 flex items-center gap-2 rounded-2xl border border-white/10 bg-white/[0.035] px-3 py-2 text-slate-500">
        <Search className="h-4 w-4" />
        <span className="text-xs">Search schemas...</span>
      </div>

      <nav className="space-y-1.5">
        {navigation.map((item) => {
          const Icon = item.icon;

          return (
            <a
              key={item.label}
              className={`group flex items-center gap-3 rounded-2xl px-3 py-3 text-sm transition ${
                item.active
                  ? "bg-cyan-300 text-slate-950 shadow-lg shadow-cyan-950/30"
                  : "text-slate-400 hover:bg-white/10 hover:text-white"
              }`}
              href="#"
            >
              <Icon className="h-4 w-4" />
              {item.label}
            </a>
          );
        })}
      </nav>

      <div className="mt-6 flex-1 rounded-3xl border border-white/10 bg-white/[0.035] p-3">
        <div className="mb-3 flex items-center justify-between px-1">
          <div className="flex items-center gap-2 text-sm font-medium text-slate-200">
            <Table2 className="h-4 w-4 text-cyan-300" />
            Schema explorer
          </div>
          <span className="rounded-full bg-cyan-300/10 px-2 py-1 text-[10px] text-cyan-200">
            soon
          </span>
        </div>

        <div className="space-y-2">
          {schemaTables.map((table, index) => (
            <motion.div
              key={table.name}
              initial={{ opacity: 0, y: 8 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.1 + index * 0.05, duration: 0.35 }}
              className="rounded-2xl border border-white/5 bg-slate-950/60 p-3 transition hover:border-cyan-300/20 hover:bg-slate-900/80"
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Braces className="h-3.5 w-3.5 text-slate-500" />
                  <span className="text-sm text-slate-200">{table.name}</span>
                </div>
                {table.hot && (
                  <span className="rounded-full bg-emerald-300/10 px-2 py-0.5 text-[10px] text-emerald-200">
                    joined
                  </span>
                )}
              </div>
              <p className="mt-1 pl-5 text-xs text-slate-600">{table.columns} columns</p>
            </motion.div>
          ))}
        </div>
      </div>
    </motion.aside>
  );
}
