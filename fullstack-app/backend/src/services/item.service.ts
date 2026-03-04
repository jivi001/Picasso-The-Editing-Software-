import { StatusCodes } from "http-status-codes";

import { itemRepository } from "../repositories/item.repository";
import { DashboardSummary, Item, ItemStatus } from "../types/models";
import { HttpError } from "../utils/httpError";

type CreateItemInput = {
  title: string;
  description?: string;
  status?: ItemStatus;
  dueDate?: string | null;
};

type UpdateItemInput = Partial<CreateItemInput>;

export const listItemsForUser = async (userId: number): Promise<Item[]> => {
  return itemRepository.findManyByUserId(userId);
};

export const getItemForUser = async (itemId: number, userId: number): Promise<Item> => {
  const item = await itemRepository.findByIdAndUserId(itemId, userId);
  if (!item) {
    throw new HttpError(StatusCodes.NOT_FOUND, "Item not found");
  }

  return item;
};

export const createItemForUser = async (userId: number, input: CreateItemInput): Promise<Item> => {
  return itemRepository.createForUser(userId, input);
};

export const updateItemForUser = async (
  itemId: number,
  userId: number,
  input: UpdateItemInput
): Promise<Item> => {
  if (Object.keys(input).length === 0) {
    throw new HttpError(StatusCodes.BAD_REQUEST, "No updatable fields supplied");
  }

  const updated = await itemRepository.updateForUser(itemId, userId, input);
  if (!updated) {
    throw new HttpError(StatusCodes.NOT_FOUND, "Item not found");
  }

  return updated;
};

export const deleteItemForUser = async (itemId: number, userId: number): Promise<void> => {
  const deleted = await itemRepository.deleteForUser(itemId, userId);
  if (!deleted) {
    throw new HttpError(StatusCodes.NOT_FOUND, "Item not found");
  }
};

export const getSummaryForUser = async (userId: number): Promise<DashboardSummary> =>
  itemRepository.getSummaryForUser(userId);
