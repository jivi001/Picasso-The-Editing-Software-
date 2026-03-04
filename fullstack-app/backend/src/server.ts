import app from "./app";
import { env } from "./config/env";
import { logger } from "./config/logger";
import { pool, query } from "./db/pool";

const startServer = async (): Promise<void> => {
  try {
    await query("SELECT 1");
    const server = app.listen(env.PORT, () => {
      logger.info(`Backend listening on http://localhost:${env.PORT}`);
    });

    const shutdown = async (): Promise<void> => {
      logger.info("Gracefully shutting down backend");
      server.close(async () => {
        await pool.end();
        process.exit(0);
      });
    };

    process.on("SIGINT", shutdown);
    process.on("SIGTERM", shutdown);
  } catch (error) {
    logger.error("Failed to initialize backend", {
      error: error instanceof Error ? error.message : String(error)
    });
    process.exit(1);
  }
};

void startServer();
