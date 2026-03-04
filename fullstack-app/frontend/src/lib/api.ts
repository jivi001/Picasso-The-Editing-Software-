export type ItemStatus = "todo" | "in_progress" | "done";

export interface User {
  id: number;
  email: string;
  fullName: string;
  createdAt: string;
}

export interface Item {
  id: number;
  userId: number;
  title: string;
  description: string | null;
  status: ItemStatus;
  dueDate: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface ItemPayload {
  title?: string;
  description?: string;
  status?: ItemStatus;
  dueDate?: string | null;
}

export interface DashboardSummary {
  total: number;
  active: number;
  done: number;
}

interface AuthPayload {
  email: string;
  password: string;
}

interface SignupPayload extends AuthPayload {
  fullName: string;
}

export class ApiError extends Error {
  statusCode: number;
  details?: unknown;

  constructor(statusCode: number, message: string, details?: unknown) {
    super(message);
    this.statusCode = statusCode;
    this.details = details;
  }
}

const API_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:4000/api";

const parseResponseBody = async (response: Response): Promise<unknown> => {
  const contentType = response.headers.get("content-type") ?? "";

  if (!contentType.includes("application/json")) {
    return null;
  }

  return response.json();
};

const request = async <T>(
  path: string,
  init: RequestInit & { token?: string } = {}
): Promise<T> => {
  const headers = new Headers(init.headers ?? {});
  if (!headers.has("Content-Type")) {
    headers.set("Content-Type", "application/json");
  }

  if (init.token) {
    headers.set("Authorization", `Bearer ${init.token}`);
  }

  const response = await fetch(`${API_URL}${path}`, {
    ...init,
    headers
  });

  const data = (await parseResponseBody(response)) as Record<string, unknown> | null;
  if (!response.ok) {
    throw new ApiError(
      response.status,
      (data?.message as string | undefined) ?? "Request failed",
      data?.details
    );
  }

  return (data ?? {}) as T;
};

export const apiClient = {
  signup: (payload: SignupPayload) =>
    request<{ user: User; token: string }>("/auth/signup", {
      method: "POST",
      body: JSON.stringify(payload)
    }),

  login: (payload: AuthPayload) =>
    request<{ user: User; token: string }>("/auth/login", {
      method: "POST",
      body: JSON.stringify(payload)
    }),

  logout: (token: string) =>
    request<{ message: string }>("/auth/logout", {
      method: "POST",
      token
    }),

  me: (token: string) =>
    request<{ user: User }>("/auth/me", {
      method: "GET",
      token
    }),

  dashboardSummary: (token: string) =>
    request<{ summary: DashboardSummary }>("/dashboard/summary", {
      method: "GET",
      token
    }),

  listItems: (token: string) =>
    request<{ items: Item[] }>("/items", {
      method: "GET",
      token
    }),

  createItem: (token: string, payload: ItemPayload) =>
    request<{ item: Item }>("/items", {
      method: "POST",
      token,
      body: JSON.stringify(payload)
    }),

  updateItem: (token: string, id: number, payload: ItemPayload) =>
    request<{ item: Item }>(`/items/${id}`, {
      method: "PUT",
      token,
      body: JSON.stringify(payload)
    }),

  deleteItem: (token: string, id: number) =>
    request<{ message: string }>(`/items/${id}`, {
      method: "DELETE",
      token
    })
};
