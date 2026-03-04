import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";

import { getUserById, loginUser, registerUser } from "../services/auth.service";
import { HttpError } from "../utils/httpError";

export const signup = async (req: Request, res: Response): Promise<void> => {
  const result = await registerUser(req.body);
  res.status(StatusCodes.CREATED).json(result);
};

export const login = async (req: Request, res: Response): Promise<void> => {
  const result = await loginUser(req.body);
  res.status(StatusCodes.OK).json(result);
};

export const logout = async (_req: Request, res: Response): Promise<void> => {
  res.status(StatusCodes.OK).json({
    message: "Logged out successfully. Remove the token from the client."
  });
};

export const me = async (req: Request, res: Response): Promise<void> => {
  if (!req.user) {
    throw new HttpError(StatusCodes.UNAUTHORIZED, "Authentication required");
  }

  const user = await getUserById(req.user.id);
  if (!user) {
    throw new HttpError(StatusCodes.NOT_FOUND, "User not found");
  }

  res.status(StatusCodes.OK).json({ user });
};
