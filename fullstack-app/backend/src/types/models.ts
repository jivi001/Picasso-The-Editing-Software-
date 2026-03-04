export type ItemStatus = "todo" | "in_progress" | "done";

export interface PublicUser {
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

export interface DashboardSummary {
  total: number;
  active: number;
  done: number;
}
