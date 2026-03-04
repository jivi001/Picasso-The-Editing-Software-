import { Request, Response } from "express";
import { StatusCodes } from "http-status-codes";

import { getSummaryForUser } from "../services/item.service";
import { HttpError } from "../utils/httpError";

export const getDashboardSummary = async (req: Request, res: Response): Promise<void> => {
  if (!req.user) {
    throw new HttpError(StatusCodes.UNAUTHORIZED, "Authentication required");
  }

  const summary = await getSummaryForUser(req.user.id);
  res.status(StatusCodes.OK).json({ summary });
};
