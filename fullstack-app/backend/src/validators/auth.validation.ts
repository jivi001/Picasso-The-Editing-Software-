import { z } from "zod";

export const signupSchema = z.object({
  fullName: z.string().trim().min(2).max(120),
  email: z.string().trim().email(),
  password: z
    .string()
    .min(8)
    .max(72)
    .regex(/[A-Z]/, "Password must include at least one uppercase letter")
    .regex(/[a-z]/, "Password must include at least one lowercase letter")
    .regex(/[0-9]/, "Password must include at least one number")
});

export const loginSchema = z.object({
  email: z.string().trim().email(),
  password: z.string().min(1)
});
