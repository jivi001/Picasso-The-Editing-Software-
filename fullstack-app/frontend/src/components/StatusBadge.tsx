import { ItemStatus } from "@/lib/api";

const statusStyles: Record<ItemStatus, string> = {
  todo: "bg-slate-100 text-slate-700 border-slate-200",
  in_progress: "bg-amber-100 text-amber-700 border-amber-200",
  done: "bg-emerald-100 text-emerald-700 border-emerald-200"
};

const statusLabels: Record<ItemStatus, string> = {
  todo: "To do",
  in_progress: "In progress",
  done: "Done"
};

interface StatusBadgeProps {
  status: ItemStatus;
}

export default function StatusBadge({ status }: StatusBadgeProps) {
  return (
    <span className={`inline-flex rounded-full border px-2.5 py-1 text-xs font-medium ${statusStyles[status]}`}>
      {statusLabels[status]}
    </span>
  );
}
