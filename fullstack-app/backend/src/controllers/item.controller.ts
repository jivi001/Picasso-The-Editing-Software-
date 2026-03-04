import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";

import {
  createItemForUser,
  deleteItemForUser,
  getItemForUser,
  listItemsForUser,
  updateItemForUser
} from "../services/item.service";
import { HttpError } from "../utils/httpError";

const assertUser = (req: Request): { id: number; email: string } => {
  if (!req.user) {
    throw new HttpError(StatusCodes.UNAUTHORIZED, "Authentication required");
  }
  return req.user;
};

export const listItems = async (req: Request, res: Response): Promise<void> => {
  const user = assertUser(req);
  const items = await listItemsForUser(user.id);
  res.status(StatusCodes.OK).json({ items });
};

export const getItem = async (req: Request, res: Response): Promise<void> => {
  const user = assertUser(req);
  const item = await getItemForUser(Number(req.params.id), user.id);
  res.status(StatusCodes.OK).json({ item });
};

export const createItem = async (req: Request, res: Response): Promise<void> => {
  const user = assertUser(req);
  const item = await createItemForUser(user.id, req.body);
  res.status(StatusCodes.CREATED).json({ item });
};

export const updateItem = async (req: Request, res: Response): Promise<void> => {
  const user = assertUser(req);
  const item = await updateItemForUser(Number(req.params.id), user.id, req.body);
  res.status(StatusCodes.OK).json({ item });
};

export const deleteItem = async (req: Request, res: Response): Promise<void> => {
  const user = assertUser(req);
  await deleteItemForUser(Number(req.params.id), user.id);
  res.status(StatusCodes.OK).json({ message: "Item deleted successfully" });
};
