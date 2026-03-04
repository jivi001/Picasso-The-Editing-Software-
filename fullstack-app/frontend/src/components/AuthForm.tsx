"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { FormEvent, useEffect, useMemo, useState } from "react";

import { ApiError, apiClient } from "@/lib/api";
import { authStorage } from "@/lib/auth";

type Mode = "login" | "signup";

interface AuthFormProps {
  mode: Mode;
}

export default function AuthForm({ mode }: AuthFormProps) {
  const router = useRouter();
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const config = useMemo(
    () =>
      mode === "login"
        ? {
            title: "Welcome back",
            subtitle: "Log in to manage your dashboard tasks.",
            cta: "Log in",
            footerText: "Need an account?",
            footerLinkLabel: "Sign up",
            footerHref: "/signup"
          }
        : {
            title: "Create your account",
            subtitle: "Start organizing tasks with secure JWT sessions.",
            cta: "Sign up",
            footerText: "Already have an account?",
            footerLinkLabel: "Log in",
            footerHref: "/login"
          },
    [mode]
  );

  useEffect(() => {
    const token = authStorage.getToken();
    if (token) {
      router.replace("/dashboard");
    }
  }, [router]);

  const onSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setError(null);
    setIsSubmitting(true);

    try {
      const response =
        mode === "login"
          ? await apiClient.login({ email, password })
          : await apiClient.signup({ fullName, email, password });

      authStorage.setToken(response.token);
      router.replace("/dashboard");
    } catch (submitError) {
      if (submitError instanceof ApiError) {
        setError(submitError.message);
      } else {
        setError("Unable to complete request. Please retry.");
      }
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <main className="flex min-h-screen items-center justify-center px-5 py-14">
      <section className="card-surface w-full max-w-md p-8">
        <h1 className="text-3xl font-semibold text-ink">{config.title}</h1>
        <p className="mt-2 text-sm text-slate-600">{config.subtitle}</p>

        <form className="mt-8 space-y-4" onSubmit={onSubmit}>
          {mode === "signup" && (
            <label className="block text-sm">
              <span className="mb-1 block text-slate-700">Full name</span>
              <input
                value={fullName}
                onChange={(event) => setFullName(event.target.value)}
                className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2 outline-none transition focus:border-accent focus:ring-2 focus:ring-accent/20"
                placeholder="Jordan Lee"
                required
              />
            </label>
          )}

          <label className="block text-sm">
            <span className="mb-1 block text-slate-700">Email</span>
            <input
              type="email"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2 outline-none transition focus:border-accent focus:ring-2 focus:ring-accent/20"
              placeholder="you@company.com"
              required
            />
          </label>

          <label className="block text-sm">
            <span className="mb-1 block text-slate-700">Password</span>
            <input
              type="password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              className="w-full rounded-xl border border-slate-300 bg-white px-3 py-2 outline-none transition focus:border-accent focus:ring-2 focus:ring-accent/20"
              placeholder="Minimum 8 chars, mixed case + number"
              required
              minLength={8}
            />
          </label>

          {error && (
            <p className="rounded-xl border border-rose-200 bg-rose-50 px-3 py-2 text-sm text-rose-700">{error}</p>
          )}

          <button
            type="submit"
            disabled={isSubmitting}
            className="w-full rounded-xl bg-accent px-4 py-2.5 font-medium text-white transition hover:bg-teal-700 disabled:cursor-not-allowed disabled:opacity-70"
          >
            {isSubmitting ? "Please wait..." : config.cta}
          </button>
        </form>

        <p className="mt-6 text-sm text-slate-600">
          {config.footerText}{" "}
          <Link className="font-semibold text-accent hover:underline" href={config.footerHref}>
            {config.footerLinkLabel}
          </Link>
        </p>
      </section>
    </main>
  );
}
