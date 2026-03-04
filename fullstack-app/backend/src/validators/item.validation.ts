import { z } from "zod";

const itemStatusSchema = z.enum(["todo", "in_progress", "done"]);

const dueDateSchema = z
  .union([z.string().regex(/^\d{4}-\d{2}-\d{2}$/), z.null()])
  .optional();

export const createItemSchema = z.object({
  title: z.string().trim().min(1).max(120),
  description: z.string().trim().max(1000).optional(),
  status: itemStatusSchema.optional(),
  dueDate: dueDateSchema
});

export const updateItemSchema = createItemSchema
  .partial()
  .refine((data) => Object.keys(data).length > 0, "At least one field must be provided");

export const itemParamsSchema = z.object({
  id: z.coerce.number().int().positive()
});
