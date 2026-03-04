import { Router } from "express";

import { getCurrentUser, getUsers } from "../controllers/user.controller";
import { requireAuth } from "../middleware/auth";
import { asyncHandler } from "../utils/asyncHandler";

const userRouter = Router();

userRouter.use(requireAuth);
userRouter.get("/", asyncHandler(getUsers));
userRouter.get("/me", asyncHandler(getCurrentUser));

export default userRouter;
