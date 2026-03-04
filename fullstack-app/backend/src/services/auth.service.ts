import { StatusCodes } from "http-status-codes";

import { userRepository } from "../repositories/user.repository";
import { PublicUser } from "../types/models";
import { HttpError } from "../utils/httpError";
import { signAccessToken } from "../utils/jwt";
import { comparePassword, hashPassword } from "../utils/password";

type NewUserInput = {
  fullName: string;
  email: string;
  password: string;
};

type LoginInput = {
  email: string;
  password: string;
};

export const registerUser = async (input: NewUserInput): Promise<{ user: PublicUser; token: string }> => {
  const existing = await userRepository.findByEmail(input.email);
  if (existing) {
    throw new HttpError(StatusCodes.CONFLICT, "A user with this email already exists");
  }

  const passwordHash = await hashPassword(input.password);
  const inserted = await userRepository.create({
    fullName: input.fullName,
    email: input.email,
    passwordHash
  });

  const user = userRepository.toPublicUser(inserted);
  return {
    user,
    token: signAccessToken({ id: user.id, email: user.email })
  };
};

export const loginUser = async (input: LoginInput): Promise<{ user: PublicUser; token: string }> => {
  const row = await userRepository.findByEmail(input.email);

  if (!row) {
    throw new HttpError(StatusCodes.UNAUTHORIZED, "Invalid email or password");
  }

  const passwordMatches = await comparePassword(input.password, row.password_hash);
  if (!passwordMatches) {
    throw new HttpError(StatusCodes.UNAUTHORIZED, "Invalid email or password");
  }

  const user = userRepository.toPublicUser(row);
  return {
    user,
    token: signAccessToken({ id: user.id, email: user.email })
  };
};

export const getUserById = async (id: number): Promise<PublicUser | null> => {
  const user = await userRepository.findById(id);
  return user ? userRepository.toPublicUser(user) : null;
};
