import { NextFunction, Request, Response } from "express";
import { StatusCodes } from "http-status-codes";
import { ZodError } from "zod";

import { env } from "../config/env";
import { HttpError } from "../utils/httpError";

type PgError = {
  code?: string;
  detail?: string;
};

export const errorHandler = (
  error: unknown,
  _req: Request,
  res: Response,
  _next: NextFunction
): void => {
  if (error instanceof ZodError) {
    res.status(StatusCodes.BAD_REQUEST).json({
      message: "Validation failed",
      details: error.flatten()
    });
    return;
  }

  if (error instanceof HttpError) {
    res.status(error.statusCode).json({
      message: error.message,
      details: error.details
    });
    return;
  }

  const pgError = error as PgError;
  if (pgError?.code === "23505") {
    res.status(StatusCodes.CONFLICT).json({
      message: "Duplicate value violates a unique constraint",
      details: pgError.detail
    });
    return;
  }

  res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({
    message: "Internal server error",
    ...(env.NODE_ENV !== "production"
      ? { details: error instanceof Error ? error.message : String(error) }
      : {})
  });
};
