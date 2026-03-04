import { Router } from "express";

import { login, logout, me, signup } from "../controllers/auth.controller";
import { requireAuth } from "../middleware/auth";
import { validate } from "../middleware/validate";
import { asyncHandler } from "../utils/asyncHandler";
import { loginSchema, signupSchema } from "../validators/auth.validation";

const authRouter = Router();

authRouter.post("/signup", validate(signupSchema), asyncHandler(signup));
authRouter.post("/login", validate(loginSchema), asyncHandler(login));
authRouter.post("/logout", requireAuth, asyncHandler(logout));
authRouter.get("/me", requireAuth, asyncHandler(me));

export default authRouter;
