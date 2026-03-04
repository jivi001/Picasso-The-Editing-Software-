import { Item } from "@/lib/api";

import StatusBadge from "./StatusBadge";

interface ItemCardProps {
  item: Item;
  onEdit: (item: Item) => void;
  onDelete: (item: Item) => void;
  deleting?: boolean;
}

export default function ItemCard({ item, onEdit, onDelete, deleting = false }: ItemCardProps) {
  return (
    <article className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition hover:shadow-md">
      <div className="flex items-start justify-between gap-4">
        <h3 className="text-lg font-semibold text-ink">{item.title}</h3>
        <StatusBadge status={item.status} />
      </div>

      <p className="mt-2 min-h-10 text-sm text-slate-600">{item.description || "No description provided."}</p>

      <div className="mt-4 flex flex-wrap items-center justify-between gap-2 text-xs text-slate-500">
        <span>Due: {item.dueDate ?? "Not set"}</span>
        <span>Updated: {new Date(item.updatedAt).toLocaleString()}</span>
      </div>

      <div className="mt-4 flex gap-2">
        <button
          type="button"
          onClick={() => onEdit(item)}
          className="rounded-lg border border-slate-300 px-3 py-1.5 text-sm font-medium text-slate-700 transition hover:border-slate-400"
        >
          Edit
        </button>
        <button
          type="button"
          disabled={deleting}
          onClick={() => onDelete(item)}
          className="rounded-lg border border-rose-200 bg-rose-50 px-3 py-1.5 text-sm font-medium text-rose-700 transition hover:border-rose-300 disabled:cursor-not-allowed disabled:opacity-60"
        >
          {deleting ? "Deleting..." : "Delete"}
        </button>
      </div>
    </article>
  );
}
