import cors from "cors";
import express from "express";
import helmet from "helmet";

import { env } from "./config/env";
import { requestLogger } from "./config/logger";
import { errorHandler } from "./middleware/errorHandler";
import { notFoundHandler } from "./middleware/notFound";
import { apiRateLimiter } from "./middleware/rateLimiter";
import apiRouter from "./routes";

const app = express();

app.use(helmet());
app.use(
  cors({
    origin: env.FRONTEND_URL,
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"]
  })
);

app.use(requestLogger);
app.use(express.json({ limit: "1mb" }));
app.use(apiRateLimiter);
app.use("/api", apiRouter);
app.use(notFoundHandler);
app.use(errorHandler);

export default app;
