import { query } from "../db/pool";
import { PublicUser } from "../types/models";

type UserRow = {
  id: number;
  email: string;
  full_name: string;
  password_hash: string;
  created_at: string;
};

const mapPublicUser = (row: UserRow): PublicUser => ({
  id: row.id,
  email: row.email,
  fullName: row.full_name,
  createdAt: row.created_at
});

export const userRepository = {
  findByEmail: async (email: string): Promise<UserRow | null> => {
    const result = await query<UserRow>("SELECT * FROM users WHERE email = $1", [email.toLowerCase()]);
    return result.rows[0] ?? null;
  },

  findById: async (id: number): Promise<UserRow | null> => {
    const result = await query<UserRow>("SELECT * FROM users WHERE id = $1", [id]);
    return result.rows[0] ?? null;
  },

  create: async (params: { fullName: string; email: string; passwordHash: string }): Promise<UserRow> => {
    const result = await query<UserRow>(
      `
        INSERT INTO users (full_name, email, password_hash)
        VALUES ($1, $2, $3)
        RETURNING id, email, full_name, password_hash, created_at
      `,
      [params.fullName, params.email.toLowerCase(), params.passwordHash]
    );

    return result.rows[0];
  },

  toPublicUser: mapPublicUser
};

export type { UserRow };
