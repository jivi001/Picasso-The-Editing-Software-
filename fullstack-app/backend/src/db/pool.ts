import { Pool, PoolClient, QueryResult } from "pg";

import { env } from "../config/env";
import { logger } from "../config/logger";

export const pool = new Pool({
  connectionString: env.DATABASE_URL
});

pool.on("error", (error) => {
  logger.error("Unexpected PostgreSQL error", { error: error.message });
});

export const query = <T = unknown>(text: string, params: unknown[] = []): Promise<QueryResult<T>> =>
  pool.query<T>(text, params);

export const withTransaction = async <T>(callback: (client: PoolClient) => Promise<T>): Promise<T> => {
  const client = await pool.connect();
  try {
    await client.query("BEGIN");
    const result = await callback(client);
    await client.query("COMMIT");
    return result;
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  } finally {
    client.release();
  }
};
