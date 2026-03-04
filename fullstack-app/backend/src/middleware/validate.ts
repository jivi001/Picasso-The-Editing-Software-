import { NextFunction, Request, Response } from "express";
import { z } from "zod";

import { HttpError } from "../utils/httpError";

type Target = "body" | "params" | "query";

export const validate =
  <T extends z.ZodTypeAny>(schema: T, target: Target = "body") =>
  (req: Request, _res: Response, next: NextFunction): void => {
    const result = schema.safeParse((req as Request & Record<Target, unknown>)[target]);

    if (!result.success) {
      next(new HttpError(400, "Validation failed", result.error.flatten()));
      return;
    }

    (req as Request & Record<Target, unknown>)[target] = result.data;
    next();
  };
