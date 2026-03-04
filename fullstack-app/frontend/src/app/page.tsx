import Link from "next/link";

export default function HomePage() {
  return (
    <main className="mx-auto flex min-h-screen w-full max-w-6xl flex-col justify-center px-6 py-16">
      <section className="card-surface grid gap-10 p-10 md:grid-cols-[1.2fr_1fr] md:p-14">
        <div className="space-y-6">
          <p className="inline-flex rounded-full border border-accent/30 bg-accent/10 px-3 py-1 font-[family-name:var(--font-mono)] text-xs uppercase tracking-[0.2em] text-accent">
            Production starter
          </p>
          <h1 className="text-4xl font-semibold leading-tight text-ink md:text-5xl">
            TaskForge tracks your work from idea to shipped release.
          </h1>
          <p className="max-w-xl text-base text-slate-600">
            Full-stack template powered by Next.js, Express, PostgreSQL, JWT auth, and Docker. Sign in to access your
            task dashboard.
          </p>
          <div className="flex flex-wrap gap-3">
            <Link
              href="/signup"
              className="rounded-xl bg-accent px-5 py-3 font-medium text-white transition hover:bg-teal-700"
            >
              Create account
            </Link>
            <Link
              href="/login"
              className="rounded-xl border border-slate-300 bg-white px-5 py-3 font-medium text-slate-700 transition hover:border-slate-400"
            >
              Log in
            </Link>
          </div>
        </div>
        <div className="rounded-2xl border border-slate-200 bg-slate-50 p-6">
          <h2 className="mb-4 text-lg font-semibold">What is included</h2>
          <ul className="space-y-3 text-sm text-slate-600">
            <li>JWT signup and login with bcrypt hashing</li>
            <li>REST API with rate limiting and validation</li>
            <li>CRUD task dashboard with responsive UI</li>
            <li>PostgreSQL schema + migration runner</li>
            <li>Dockerized frontend, backend, and database</li>
          </ul>
        </div>
      </section>
    </main>
  );
}
