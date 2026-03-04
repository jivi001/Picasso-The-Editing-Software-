import { Router } from "express";
import { StatusCodes } from "http-status-codes";

import authRouter from "./auth.routes";
import dashboardRouter from "./dashboard.routes";
import itemRouter from "./item.routes";
import userRouter from "./user.routes";

const apiRouter = Router();

apiRouter.get("/health", (_req, res) => {
  res.status(StatusCodes.OK).json({
    status: "ok",
    timestamp: new Date().toISOString()
  });
});

apiRouter.use("/auth", authRouter);
apiRouter.use("/dashboard", dashboardRouter);
apiRouter.use("/items", itemRouter);
apiRouter.use("/users", userRouter);

export default apiRouter;
