"use client";

import { FormEvent } from "react";

import { ItemStatus } from "@/lib/api";

export interface ItemDraft {
  title: string;
  description: string;
  status: ItemStatus;
  dueDate: string;
}

interface ItemFormProps {
  draft: ItemDraft;
  onChange: (nextDraft: ItemDraft) => void;
  onSubmit: () => void;
  onCancel?: () => void;
  busy?: boolean;
  submitLabel: string;
}

export default function ItemForm({ draft, onChange, onSubmit, onCancel, busy = false, submitLabel }: ItemFormProps) {
  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    onSubmit();
  };

  return (
    <form className="grid gap-4" onSubmit={handleSubmit}>
      <label className="text-sm">
        <span className="mb-1 block font-medium text-slate-700">Title</span>
        <input
          value={draft.title}
          onChange={(event) => onChange({ ...draft, title: event.target.value })}
          className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2 outline-none transition focus:border-accent focus:ring-2 focus:ring-accent/20"
          placeholder="Plan sprint review"
          maxLength={120}
          required
        />
      </label>

      <label className="text-sm">
        <span className="mb-1 block font-medium text-slate-700">Description</span>
        <textarea
          value={draft.description}
          onChange={(event) => onChange({ ...draft, description: event.target.value })}
          className="h-24 w-full rounded-xl border border-slate-300 bg-white px-3 py-2 outline-none transition focus:border-accent focus:ring-2 focus:ring-accent/20"
          placeholder="Add key details and acceptance criteria"
          maxLength={1000}
        />
      </label>

      <div className="grid gap-4 sm:grid-cols-2">
        <label className="text-sm">
          <span className="mb-1 block font-medium text-slate-700">Status</span>
          <select
            value={draft.status}
            onChange={(event) => onChange({ ...draft, status: event.target.value as ItemStatus })}
            className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2 outline-none transition focus:border-accent focus:ring-2 focus:ring-accent/20"
          >
            <option value="todo">To do</option>
            <option value="in_progress">In progress</option>
            <option value="done">Done</option>
          </select>
        </label>

        <label className="text-sm">
          <span className="mb-1 block font-medium text-slate-700">Due date</span>
          <input
            type="date"
            value={draft.dueDate}
            onChange={(event) => onChange({ ...draft, dueDate: event.target.value })}
            className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2 outline-none transition focus:border-accent focus:ring-2 focus:ring-accent/20"
          />
        </label>
      </div>

      <div className="flex flex-wrap gap-2">
        <button
          type="submit"
          disabled={busy}
          className="rounded-xl bg-accent px-4 py-2 font-medium text-white transition hover:bg-teal-700 disabled:cursor-not-allowed disabled:opacity-70"
        >
          {busy ? "Saving..." : submitLabel}
        </button>
        {onCancel && (
          <button
            type="button"
            onClick={onCancel}
            disabled={busy}
            className="rounded-xl border border-slate-300 bg-white px-4 py-2 font-medium text-slate-700 transition hover:border-slate-400 disabled:cursor-not-allowed disabled:opacity-70"
          >
            Cancel
          </button>
        )}
      </div>
    </form>
  );
}
