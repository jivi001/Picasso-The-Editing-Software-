import jwt, { SignOptions } from "jsonwebtoken";

import { env } from "../config/env";

interface AccessTokenPayload {
  sub: string;
  email: string;
}

export const signAccessToken = (user: { id: number; email: string }): string => {
  const payload: AccessTokenPayload = {
    sub: String(user.id),
    email: user.email
  };

  const options: SignOptions = {
    expiresIn: env.JWT_EXPIRES_IN as SignOptions["expiresIn"]
  };

  return jwt.sign(payload, env.JWT_SECRET, options);
};

export const verifyAccessToken = (token: string): { id: number; email: string } => {
  const decoded = jwt.verify(token, env.JWT_SECRET) as jwt.JwtPayload & AccessTokenPayload;

  if (!decoded.sub || !decoded.email) {
    throw new Error("Invalid token payload");
  }

  return {
    id: Number(decoded.sub),
    email: decoded.email
  };
};
