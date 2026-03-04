import { query } from "../db/pool";
import { DashboardSummary, Item, ItemStatus } from "../types/models";

type ItemRow = {
  id: number;
  user_id: number;
  title: string;
  description: string | null;
  status: ItemStatus;
  due_date: string | null;
  created_at: string;
  updated_at: string;
};

type SummaryRow = {
  total: number;
  done: number;
};

const mapItem = (row: ItemRow): Item => ({
  id: row.id,
  userId: row.user_id,
  title: row.title,
  description: row.description,
  status: row.status,
  dueDate: row.due_date,
  createdAt: row.created_at,
  updatedAt: row.updated_at
});

export const itemRepository = {
  findManyByUserId: async (userId: number): Promise<Item[]> => {
    const result = await query<ItemRow>(
      `
        SELECT id, user_id, title, description, status, due_date, created_at, updated_at
        FROM items
        WHERE user_id = $1
        ORDER BY created_at DESC
      `,
      [userId]
    );

    return result.rows.map(mapItem);
  },

  findByIdAndUserId: async (itemId: number, userId: number): Promise<Item | null> => {
    const result = await query<ItemRow>(
      `
        SELECT id, user_id, title, description, status, due_date, created_at, updated_at
        FROM items
        WHERE id = $1 AND user_id = $2
      `,
      [itemId, userId]
    );

    return result.rows[0] ? mapItem(result.rows[0]) : null;
  },

  createForUser: async (
    userId: number,
    input: { title: string; description?: string; status?: ItemStatus; dueDate?: string | null }
  ): Promise<Item> => {
    const result = await query<ItemRow>(
      `
        INSERT INTO items (user_id, title, description, status, due_date)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING id, user_id, title, description, status, due_date, created_at, updated_at
      `,
      [userId, input.title, input.description ?? null, input.status ?? "todo", input.dueDate ?? null]
    );

    return mapItem(result.rows[0]);
  },

  updateForUser: async (
    itemId: number,
    userId: number,
    input: {
      title?: string;
      description?: string;
      status?: ItemStatus;
      dueDate?: string | null;
    }
  ): Promise<Item | null> => {
    const setClauses: string[] = [];
    const values: unknown[] = [];
    let index = 1;

    if (typeof input.title !== "undefined") {
      setClauses.push(`title = $${index++}`);
      values.push(input.title);
    }
    if (typeof input.description !== "undefined") {
      setClauses.push(`description = $${index++}`);
      values.push(input.description || null);
    }
    if (typeof input.status !== "undefined") {
      setClauses.push(`status = $${index++}`);
      values.push(input.status);
    }
    if (typeof input.dueDate !== "undefined") {
      setClauses.push(`due_date = $${index++}`);
      values.push(input.dueDate);
    }

    if (setClauses.length === 0) {
      return null;
    }

    setClauses.push("updated_at = NOW()");
    values.push(itemId, userId);

    const result = await query<ItemRow>(
      `
        UPDATE items
        SET ${setClauses.join(", ")}
        WHERE id = $${index++} AND user_id = $${index}
        RETURNING id, user_id, title, description, status, due_date, created_at, updated_at
      `,
      values
    );

    return result.rows[0] ? mapItem(result.rows[0]) : null;
  },

  deleteForUser: async (itemId: number, userId: number): Promise<boolean> => {
    const result = await query<{ id: number }>(
      "DELETE FROM items WHERE id = $1 AND user_id = $2 RETURNING id",
      [itemId, userId]
    );

    return Boolean(result.rows[0]);
  },

  getSummaryForUser: async (userId: number): Promise<DashboardSummary> => {
    const result = await query<SummaryRow>(
      `
        SELECT
          COUNT(*) AS total,
          COUNT(*) FILTER (WHERE status = 'done') AS done
        FROM items
        WHERE user_id = $1
      `,
      [userId]
    );

    const row = result.rows[0] ?? { total: 0, done: 0 };
    const total = row.total;
    const done = row.done;

    return {
      total,
      done,
      active: total - done
    };
  }
};
