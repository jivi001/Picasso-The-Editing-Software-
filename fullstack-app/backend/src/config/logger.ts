import morgan from "morgan";

type Meta = Record<string, unknown> | undefined;

const write = (level: "log" | "warn" | "error", message: string, meta?: Meta): void => {
  const payload = meta ? `${message} ${JSON.stringify(meta)}` : message;
  console[level](payload);
};

export const logger = {
  info: (message: string, meta?: Meta): void => write("log", `[INFO] ${message}`, meta),
  warn: (message: string, meta?: Meta): void => write("warn", `[WARN] ${message}`, meta),
  error: (message: string, meta?: Meta): void => write("error", `[ERROR] ${message}`, meta)
};

export const requestLogger = morgan(process.env.NODE_ENV === "production" ? "combined" : "dev");
