import { signAccessToken, verifyAccessToken } from "../src/utils/jwt";

describe("jwt utilities", () => {
  it("signs and verifies a token", () => {
    const token = signAccessToken({ id: 7, email: "dev@example.com" });
    const payload = verifyAccessToken(token);

    expect(payload).toEqual({
      id: 7,
      email: "dev@example.com"
    });
  });
});
