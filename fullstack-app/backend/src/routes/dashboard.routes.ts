import { Router } from "express";

import { getDashboardSummary } from "../controllers/dashboard.controller";
import { requireAuth } from "../middleware/auth";
import { asyncHandler } from "../utils/asyncHandler";

const dashboardRouter = Router();

dashboardRouter.use(requireAuth);
dashboardRouter.get("/summary", asyncHandler(getDashboardSummary));

export default dashboardRouter;
