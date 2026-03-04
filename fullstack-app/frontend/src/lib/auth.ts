const TOKEN_KEY = "taskforge_access_token";

export const authStorage = {
  getToken: (): string | null => {
    if (typeof window === "undefined") {
      return null;
    }

    return window.localStorage.getItem(TOKEN_KEY);
  },
  setToken: (token: string): void => {
    if (typeof window === "undefined") {
      return;
    }

    window.localStorage.setItem(TOKEN_KEY, token);
  },
  clearToken: (): void => {
    if (typeof window === "undefined") {
      return;
    }

    window.localStorage.removeItem(TOKEN_KEY);
  }
};
