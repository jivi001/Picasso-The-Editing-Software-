import { StatusCodes } from "http-status-codes";

import { query } from "../db/pool";
import { PublicUser } from "../types/models";
import { HttpError } from "../utils/httpError";
import { signAccessToken } from "../utils/jwt";
import { comparePassword, hashPassword } from "../utils/password";

type UserRow = {
  id: number;
  email: string;
  full_name: string;
  password_hash: string;
  created_at: string;
};

type NewUserInput = {
  fullName: string;
  email: string;
  password: string;
};

type LoginInput = {
  email: string;
  password: string;
};

const mapPublicUser = (row: UserRow): PublicUser => ({
  id: row.id,
  email: row.email,
  fullName: row.full_name,
  createdAt: row.created_at
});

export const registerUser = async (input: NewUserInput): Promise<{ user: PublicUser; token: string }> => {
  const existing = await query<UserRow>("SELECT * FROM users WHERE email = $1", [input.email.toLowerCase()]);
  if (existing.rowCount && existing.rowCount > 0) {
    throw new HttpError(StatusCodes.CONFLICT, "A user with this email already exists");
  }

  const passwordHash = await hashPassword(input.password);
  const inserted = await query<UserRow>(
    `
      INSERT INTO users (full_name, email, password_hash)
      VALUES ($1, $2, $3)
      RETURNING id, email, full_name, password_hash, created_at
    `,
    [input.fullName, input.email.toLowerCase(), passwordHash]
  );

  const user = mapPublicUser(inserted.rows[0]);
  return {
    user,
    token: signAccessToken({ id: user.id, email: user.email })
  };
};

export const loginUser = async (input: LoginInput): Promise<{ user: PublicUser; token: string }> => {
  const result = await query<UserRow>("SELECT * FROM users WHERE email = $1", [input.email.toLowerCase()]);
  const row = result.rows[0];

  if (!row) {
    throw new HttpError(StatusCodes.UNAUTHORIZED, "Invalid email or password");
  }

  const passwordMatches = await comparePassword(input.password, row.password_hash);
  if (!passwordMatches) {
    throw new HttpError(StatusCodes.UNAUTHORIZED, "Invalid email or password");
  }

  const user = mapPublicUser(row);
  return {
    user,
    token: signAccessToken({ id: user.id, email: user.email })
  };
};

export const getUserById = async (id: number): Promise<PublicUser | null> => {
  const result = await query<UserRow>("SELECT * FROM users WHERE id = $1", [id]);
  if (!result.rows[0]) {
    return null;
  }

  return mapPublicUser(result.rows[0]);
};
