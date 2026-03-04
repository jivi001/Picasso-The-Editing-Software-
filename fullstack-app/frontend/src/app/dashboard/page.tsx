"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useMemo, useState } from "react";

import ItemCard from "@/components/ItemCard";
import ItemForm, { ItemDraft } from "@/components/ItemForm";
import { ApiError, DashboardSummary, Item, User, apiClient } from "@/lib/api";
import { authStorage } from "@/lib/auth";

const EMPTY_DRAFT: ItemDraft = {
  title: "",
  description: "",
  status: "todo",
  dueDate: ""
};

const getErrorMessage = (error: unknown, fallback: string): string => {
  if (error instanceof ApiError) {
    return error.message;
  }

  if (error instanceof Error) {
    return error.message;
  }

  return fallback;
};

export default function DashboardPage() {
  const router = useRouter();

  const [token, setToken] = useState<string | null>(null);
  const [user, setUser] = useState<User | null>(null);
  const [items, setItems] = useState<Item[]>([]);
  const [summary, setSummary] = useState<DashboardSummary>({
    total: 0,
    active: 0,
    done: 0
  });
  const [draft, setDraft] = useState<ItemDraft>(EMPTY_DRAFT);
  const [editingItemId, setEditingItemId] = useState<number | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [deletingId, setDeletingId] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);

  const metrics = useMemo(
    () => ({
      total: summary.total,
      active: summary.active,
      done: summary.done
    }),
    [summary]
  );

  const clearSessionAndRedirect = () => {
    authStorage.clearToken();
    router.replace("/login");
  };

  const bootstrapDashboard = async (accessToken: string) => {
    setIsLoading(true);
    setError(null);

    try {
      const [meResponse, itemResponse, summaryResponse] = await Promise.all([
        apiClient.me(accessToken),
        apiClient.listItems(accessToken),
        apiClient.dashboardSummary(accessToken)
      ]);
      setUser(meResponse.user);
      setItems(itemResponse.items);
      setSummary(summaryResponse.summary);
    } catch (bootstrapError) {
      if (bootstrapError instanceof ApiError && bootstrapError.statusCode === 401) {
        clearSessionAndRedirect();
        return;
      }
      setError(getErrorMessage(bootstrapError, "Failed to load dashboard data"));
    } finally {
      setIsLoading(false);
    }
  };

  const refreshSummary = async (accessToken: string): Promise<void> => {
    const summaryResponse = await apiClient.dashboardSummary(accessToken);
    setSummary(summaryResponse.summary);
  };

  useEffect(() => {
    const accessToken = authStorage.getToken();
    if (!accessToken) {
      router.replace("/login");
      return;
    }

    setToken(accessToken);
    void bootstrapDashboard(accessToken);
  }, [router]);

  const resetForm = () => {
    setEditingItemId(null);
    setDraft(EMPTY_DRAFT);
  };

  const handleSaveItem = async () => {
    if (!token) {
      clearSessionAndRedirect();
      return;
    }

    setIsSaving(true);
    setError(null);

    const payload = {
      title: draft.title.trim(),
      description: draft.description.trim(),
      status: draft.status,
      dueDate: draft.dueDate || null
    };

    try {
      if (editingItemId) {
        const response = await apiClient.updateItem(token, editingItemId, payload);
        setItems((currentItems) =>
          currentItems.map((item) => (item.id === editingItemId ? response.item : item))
        );
      } else {
        const response = await apiClient.createItem(token, payload);
        setItems((currentItems) => [response.item, ...currentItems]);
      }

      await refreshSummary(token);

      resetForm();
    } catch (saveError) {
      if (saveError instanceof ApiError && saveError.statusCode === 401) {
        clearSessionAndRedirect();
        return;
      }
      setError(getErrorMessage(saveError, "Failed to save item"));
    } finally {
      setIsSaving(false);
    }
  };

  const handleEdit = (item: Item) => {
    setEditingItemId(item.id);
    setDraft({
      title: item.title,
      description: item.description ?? "",
      status: item.status,
      dueDate: item.dueDate ?? ""
    });
  };

  const handleDelete = async (item: Item) => {
    if (!token) {
      clearSessionAndRedirect();
      return;
    }

    const shouldDelete = window.confirm(`Delete "${item.title}"?`);
    if (!shouldDelete) {
      return;
    }

    setDeletingId(item.id);
    setError(null);

    try {
      await apiClient.deleteItem(token, item.id);
      setItems((currentItems) => currentItems.filter((currentItem) => currentItem.id !== item.id));
      await refreshSummary(token);
      if (editingItemId === item.id) {
        resetForm();
      }
    } catch (deleteError) {
      if (deleteError instanceof ApiError && deleteError.statusCode === 401) {
        clearSessionAndRedirect();
        return;
      }
      setError(getErrorMessage(deleteError, "Failed to delete item"));
    } finally {
      setDeletingId(null);
    }
  };

  const handleLogout = async () => {
    if (token) {
      try {
        await apiClient.logout(token);
      } catch {
        // logout endpoint is best-effort for a stateless JWT implementation
      }
    }

    clearSessionAndRedirect();
  };

  return (
    <main className="mx-auto min-h-screen w-full max-w-6xl px-5 py-8 md:px-6 md:py-10">
      <header className="card-surface mb-6 flex flex-wrap items-center justify-between gap-4 p-6">
        <div>
          <p className="font-[family-name:var(--font-mono)] text-xs uppercase tracking-[0.2em] text-slate-500">
            Dashboard
          </p>
          <h1 className="mt-1 text-3xl font-semibold text-ink">TaskForge</h1>
          <p className="mt-1 text-sm text-slate-600">
            {user ? `Signed in as ${user.fullName} (${user.email})` : "Loading account..."}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Link
            href="/"
            className="rounded-xl border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:border-slate-400"
          >
            Home
          </Link>
          <button
            type="button"
            onClick={handleLogout}
            className="rounded-xl border border-rose-200 bg-rose-50 px-4 py-2 text-sm font-medium text-rose-700 transition hover:border-rose-300"
          >
            Log out
          </button>
        </div>
      </header>

      <section className="mb-6 grid gap-4 sm:grid-cols-3">
        <article className="card-surface p-4">
          <p className="text-sm text-slate-500">Total tasks</p>
          <p className="mt-2 text-2xl font-semibold text-ink">{metrics.total}</p>
        </article>
        <article className="card-surface p-4">
          <p className="text-sm text-slate-500">Active tasks</p>
          <p className="mt-2 text-2xl font-semibold text-ink">{metrics.active}</p>
        </article>
        <article className="card-surface p-4">
          <p className="text-sm text-slate-500">Completed tasks</p>
          <p className="mt-2 text-2xl font-semibold text-ink">{metrics.done}</p>
        </article>
      </section>

      <section className="grid gap-6 lg:grid-cols-[390px_1fr]">
        <aside className="card-surface h-fit p-5">
          <h2 className="text-xl font-semibold text-ink">{editingItemId ? "Edit item" : "New item"}</h2>
          <p className="mt-1 text-sm text-slate-600">Capture, prioritize, and ship with clear deadlines.</p>
          <div className="mt-5">
            <ItemForm
              draft={draft}
              onChange={setDraft}
              onSubmit={handleSaveItem}
              submitLabel={editingItemId ? "Update task" : "Create task"}
              onCancel={editingItemId ? resetForm : undefined}
              busy={isSaving}
            />
          </div>
        </aside>

        <section className="space-y-4">
          {error && <p className="rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-700">{error}</p>}

          {isLoading ? (
            <div className="card-surface p-6 text-slate-600">Loading your tasks...</div>
          ) : items.length === 0 ? (
            <div className="card-surface p-6 text-slate-600">
              You have no tasks yet. Create one from the panel to get started.
            </div>
          ) : (
            <div className="grid gap-4 md:grid-cols-2">
              {items.map((item) => (
                <ItemCard
                  key={item.id}
                  item={item}
                  onEdit={handleEdit}
                  onDelete={handleDelete}
                  deleting={deletingId === item.id}
                />
              ))}
            </div>
          )}
        </section>
      </section>
    </main>
  );
}
