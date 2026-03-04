import fs from "node:fs";
import path from "node:path";

import { query, withTransaction } from "./pool";

const resolveMigrationsDir = (): string => {
  const candidates = [
    path.resolve(process.cwd(), "../database/migrations"),
    path.resolve(process.cwd(), "database/migrations")
  ];

  for (const candidate of candidates) {
    if (fs.existsSync(candidate)) {
      return candidate;
    }
  }

  throw new Error("Migrations directory not found. Expected ../database/migrations");
};

const runMigrations = async (): Promise<void> => {
  const migrationsDir = resolveMigrationsDir();
  const migrationFiles = fs
    .readdirSync(migrationsDir)
    .filter((file) => file.endsWith(".sql"))
    .sort((a, b) => a.localeCompare(b));

  await query(`
    CREATE TABLE IF NOT EXISTS schema_migrations (
      id BIGSERIAL PRIMARY KEY,
      filename TEXT NOT NULL UNIQUE,
      applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);

  const applied = await query<{ filename: string }>("SELECT filename FROM schema_migrations");
  const appliedSet = new Set(applied.rows.map((row) => row.filename));

  for (const file of migrationFiles) {
    if (appliedSet.has(file)) {
      continue;
    }

    const sql = fs.readFileSync(path.join(migrationsDir, file), "utf8");
    await withTransaction(async (client) => {
      await client.query(sql);
      await client.query("INSERT INTO schema_migrations (filename) VALUES ($1)", [file]);
    });

    console.log(`Applied migration: ${file}`);
  }

  console.log("Migrations complete.");
};

runMigrations()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error("Migration failed:", error.message);
    process.exit(1);
  });
