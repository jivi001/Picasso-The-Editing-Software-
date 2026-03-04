import { Router } from "express";

import { createItem, deleteItem, getItem, listItems, updateItem } from "../controllers/item.controller";
import { requireAuth } from "../middleware/auth";
import { validate } from "../middleware/validate";
import { asyncHandler } from "../utils/asyncHandler";
import { createItemSchema, itemParamsSchema, updateItemSchema } from "../validators/item.validation";

const itemRouter = Router();

itemRouter.use(requireAuth);
itemRouter.get("/", asyncHandler(listItems));
itemRouter.get("/:id", validate(itemParamsSchema, "params"), asyncHandler(getItem));
itemRouter.post("/", validate(createItemSchema), asyncHandler(createItem));
itemRouter.put(
  "/:id",
  validate(itemParamsSchema, "params"),
  validate(updateItemSchema),
  asyncHandler(updateItem)
);
itemRouter.delete("/:id", validate(itemParamsSchema, "params"), asyncHandler(deleteItem));

export default itemRouter;
