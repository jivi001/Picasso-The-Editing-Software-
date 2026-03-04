import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";

import { getUserById } from "../services/auth.service";
import { HttpError } from "../utils/httpError";

export const getCurrentUser = async (req: Request, res: Response): Promise<void> => {
  if (!req.user) {
    throw new HttpError(StatusCodes.UNAUTHORIZED, "Authentication required");
  }

  const user = await getUserById(req.user.id);
  if (!user) {
    throw new HttpError(StatusCodes.NOT_FOUND, "User not found");
  }

  res.status(StatusCodes.OK).json({ user });
};

export const getUsers = async (req: Request, res: Response): Promise<void> => {
  if (!req.user) {
    throw new HttpError(StatusCodes.UNAUTHORIZED, "Authentication required");
  }

  const user = await getUserById(req.user.id);
  if (!user) {
    throw new HttpError(StatusCodes.NOT_FOUND, "User not found");
  }

  res.status(StatusCodes.OK).json({ users: [user] });
};
