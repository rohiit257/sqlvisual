import { BarChart3, Blocks, DatabaseZap, LayoutDashboard, Settings2 } from "lucide-react";

const navigation = [
  { label: "Dashboard", icon: LayoutDashboard, active: true },
  { label: "Datasets", icon: DatabaseZap },
  { label: "Analyses", icon: BarChart3 },
  { label: "Workflows", icon: Blocks },
  { label: "Settings", icon: Settings2 }
];

export function Sidebar() {
  return (
    <aside className="hidden w-64 shrink-0 rounded-[2rem] border border-white/10 bg-slate-950/70 p-4 shadow-2xl shadow-cyan-950/20 backdrop-blur-xl lg:block">
      <div className="mb-8 flex items-center gap-3 px-2 pt-2">
        <div className="grid h-11 w-11 place-items-center rounded-2xl bg-cyan-300 text-lg font-black text-slate-950">
          SV
        </div>
        <div>
          <p className="font-semibold text-white">SQL Visual</p>
          <p className="text-xs text-slate-500">Analytics AI</p>
        </div>
      </div>

      <nav className="space-y-2">
        {navigation.map((item) => {
          const Icon = item.icon;

          return (
            <a
              key={item.label}
              className={`flex items-center gap-3 rounded-2xl px-3 py-3 text-sm transition ${
                item.active
                  ? "bg-cyan-300 text-slate-950"
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
    </aside>
  );
}

