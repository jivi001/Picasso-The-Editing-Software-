import { NextFunction, Request, Response } from "express";
import { StatusCodes } from "http-status-codes";

import { verifyAccessToken } from "../utils/jwt";
import { HttpError } from "../utils/httpError";

export const requireAuth = (req: Request, _res: Response, next: NextFunction): void => {
  const authorizationHeader = req.headers.authorization;

  if (!authorizationHeader || !authorizationHeader.startsWith("Bearer ")) {
    next(new HttpError(StatusCodes.UNAUTHORIZED, "Authentication token missing"));
    return;
  }

  const token = authorizationHeader.slice("Bearer ".length).trim();

  try {
    req.user = verifyAccessToken(token);
    next();
  } catch {
    next(new HttpError(StatusCodes.UNAUTHORIZED, "Invalid or expired authentication token"));
  }
};
