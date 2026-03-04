import { loginSchema, signupSchema } from "../src/validators/auth.validation";
import { createItemSchema } from "../src/validators/item.validation";

describe("request validation schemas", () => {
  it("rejects weak signup passwords", () => {
    const result = signupSchema.safeParse({
      fullName: "Taylor User",
      email: "taylor@example.com",
      password: "weakpass"
    });

    expect(result.success).toBe(false);
  });

  it("accepts valid login payloads", () => {
    const result = loginSchema.safeParse({
      email: "taylor@example.com",
      password: "StrongPass123"
    });

    expect(result.success).toBe(true);
  });

  it("accepts valid item payloads", () => {
    const result = createItemSchema.safeParse({
      title: "Ship v1",
      description: "Finalize production deployment",
      status: "in_progress",
      dueDate: "2026-03-20"
    });

    expect(result.success).toBe(true);
  });
});
