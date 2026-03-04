import { comparePassword, hashPassword } from "../src/utils/password";

describe("password utilities", () => {
  it("hashes and verifies passwords", async () => {
    const plainTextPassword = "SecurePass123";
    const hashedPassword = await hashPassword(plainTextPassword);

    expect(hashedPassword).not.toBe(plainTextPassword);
    await expect(comparePassword(plainTextPassword, hashedPassword)).resolves.toBe(true);
    await expect(comparePassword("wrong-password", hashedPassword)).resolves.toBe(false);
  });
});
