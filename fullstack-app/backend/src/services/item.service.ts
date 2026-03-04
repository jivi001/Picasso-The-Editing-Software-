import { StatusCodes } from "http-status-codes";

import { query } from "../db/pool";
import { Item, ItemStatus } from "../types/models";
import { HttpError } from "../utils/httpError";

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

type CreateItemInput = {
  title: string;
  description?: string;
  status?: ItemStatus;
  dueDate?: string | null;
};

type UpdateItemInput = Partial<CreateItemInput>;

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

export const listItemsForUser = async (userId: number): Promise<Item[]> => {
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
};

export const getItemForUser = async (itemId: number, userId: number): Promise<Item> => {
  const result = await query<ItemRow>(
    `
      SELECT id, user_id, title, description, status, due_date, created_at, updated_at
      FROM items
      WHERE id = $1 AND user_id = $2
    `,
    [itemId, userId]
  );

  if (!result.rows[0]) {
    throw new HttpError(StatusCodes.NOT_FOUND, "Item not found");
  }

  return mapItem(result.rows[0]);
};

export const createItemForUser = async (userId: number, input: CreateItemInput): Promise<Item> => {
  const result = await query<ItemRow>(
    `
      INSERT INTO items (user_id, title, description, status, due_date)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING id, user_id, title, description, status, due_date, created_at, updated_at
    `,
    [userId, input.title, input.description ?? null, input.status ?? "todo", input.dueDate ?? null]
  );

  return mapItem(result.rows[0]);
};

export const updateItemForUser = async (
  itemId: number,
  userId: number,
  input: UpdateItemInput
): Promise<Item> => {
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
    throw new HttpError(StatusCodes.BAD_REQUEST, "No updatable fields supplied");
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

  if (!result.rows[0]) {
    throw new HttpError(StatusCodes.NOT_FOUND, "Item not found");
  }

  return mapItem(result.rows[0]);
};

export const deleteItemForUser = async (itemId: number, userId: number): Promise<void> => {
  const result = await query<{ id: number }>("DELETE FROM items WHERE id = $1 AND user_id = $2 RETURNING id", [
    itemId,
    userId
  ]);

  if (!result.rows[0]) {
    throw new HttpError(StatusCodes.NOT_FOUND, "Item not found");
  }
};
