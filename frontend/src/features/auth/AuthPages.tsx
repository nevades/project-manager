import { Sparkles } from 'lucide-react'
import { useState, type FormEvent, type ReactNode } from 'react'
import { Link, useLocation, useNavigate } from 'react-router'
import { Logo } from '@/components/Logo'
import { Spinner } from '@/components/Spinner'
import { useAuthConfig, useLogin, useRegister } from '@/lib/queries'

const DEMO = { email: 'demo@example.com', password: 'demo1234' }

function useRedirectAfterAuth() {
  const navigate = useNavigate()
  const location = useLocation()
  const from = (location.state as { from?: string } | null)?.from
  return () => navigate(from && from !== '/login' ? from : '/', { replace: true })
}

export function LoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const login = useLogin()
  const { data: config } = useAuthConfig()
  const redirect = useRedirectAfterAuth()

  const submit = (credentials: { email: string; password: string }) =>
    login.mutate(credentials, { onSuccess: redirect })

  const onSubmit = (event: FormEvent) => {
    event.preventDefault()
    submit({ email, password })
  }

  return (
    <AuthLayout
      title="Welcome back"
      subtitle="Sign in to pick up where you left off."
      footer={
        config?.registrationEnabled !== false && (
          <>
            New to Tasklane?{' '}
            <Link to="/register" className="font-semibold text-brand-600 hover:text-brand-700">
              Create an account
            </Link>
          </>
        )
      }
    >
      <form onSubmit={onSubmit} className="space-y-4">
        <div>
          <label htmlFor="email" className="label">
            Email
          </label>
          <input
            id="email"
            type="email"
            autoComplete="email"
            required
            className="input"
            value={email}
            onChange={(event) => setEmail(event.target.value)}
          />
        </div>
        <div>
          <label htmlFor="password" className="label">
            Password
          </label>
          <input
            id="password"
            type="password"
            autoComplete="current-password"
            required
            className="input"
            value={password}
            onChange={(event) => setPassword(event.target.value)}
          />
        </div>
        {login.error && <ErrorMessage>{login.error.message}</ErrorMessage>}
        <button type="submit" className="btn-primary w-full py-2.5" disabled={login.isPending}>
          {login.isPending && <Spinner className="size-4" />}
          Sign in
        </button>
        {config?.demoEnabled && (
          <button
            type="button"
            className="btn-secondary w-full py-2.5"
            disabled={login.isPending}
            onClick={() => {
              setEmail(DEMO.email)
              setPassword(DEMO.password)
              submit(DEMO)
            }}
          >
            <Sparkles className="size-4 text-brand-600" />
            Explore the demo workspace
          </button>
        )}
      </form>
    </AuthLayout>
  )
}

export function RegisterPage() {
  const [displayName, setDisplayName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const register = useRegister()
  const { data: config } = useAuthConfig()
  const redirect = useRedirectAfterAuth()

  const onSubmit = (event: FormEvent) => {
    event.preventDefault()
    register.mutate({ displayName, email, password }, { onSuccess: redirect })
  }

  if (config && !config.registrationEnabled) {
    return (
      <AuthLayout title="Registration is closed" subtitle="Ask an administrator to create an account for you.">
        <Link to="/login" className="btn-primary w-full py-2.5">
          Back to sign in
        </Link>
      </AuthLayout>
    )
  }

  return (
    <AuthLayout
      title="Create your account"
      subtitle="Start organising your work in minutes."
      footer={
        <>
          Already have an account?{' '}
          <Link to="/login" className="font-semibold text-brand-600 hover:text-brand-700">
            Sign in
          </Link>
        </>
      }
    >
      <form onSubmit={onSubmit} className="space-y-4">
        <div>
          <label htmlFor="name" className="label">
            Full name
          </label>
          <input
            id="name"
            autoComplete="name"
            required
            maxLength={100}
            className="input"
            value={displayName}
            onChange={(event) => setDisplayName(event.target.value)}
          />
        </div>
        <div>
          <label htmlFor="email" className="label">
            Email
          </label>
          <input
            id="email"
            type="email"
            autoComplete="email"
            required
            className="input"
            value={email}
            onChange={(event) => setEmail(event.target.value)}
          />
        </div>
        <div>
          <label htmlFor="password" className="label">
            Password
          </label>
          <input
            id="password"
            type="password"
            autoComplete="new-password"
            required
            minLength={8}
            maxLength={128}
            className="input"
            value={password}
            onChange={(event) => setPassword(event.target.value)}
          />
          <p className="mt-1.5 text-xs text-slate-500">At least 8 characters.</p>
        </div>
        {register.error && <ErrorMessage>{register.error.message}</ErrorMessage>}
        <button type="submit" className="btn-primary w-full py-2.5" disabled={register.isPending}>
          {register.isPending && <Spinner className="size-4" />}
          Create account
        </button>
      </form>
    </AuthLayout>
  )
}

function ErrorMessage({ children }: { children: ReactNode }) {
  return (
    <p role="alert" className="rounded-lg bg-red-50 px-3 py-2 text-sm text-red-700 ring-1 ring-red-200">
      {children}
    </p>
  )
}

function AuthLayout({
  title,
  subtitle,
  children,
  footer,
}: {
  title: string
  subtitle: string
  children: ReactNode
  footer?: ReactNode
}) {
  return (
    <div className="grid min-h-full lg:grid-cols-2">
      <div className="flex flex-col justify-center px-6 py-12 sm:px-12 lg:px-20">
        <div className="mx-auto w-full max-w-sm">
          <Logo />
          <h1 className="mt-10 text-2xl font-semibold tracking-tight text-slate-900">{title}</h1>
          <p className="mt-2 text-sm text-slate-600">{subtitle}</p>
          <div className="mt-8">{children}</div>
          {footer && <p className="mt-8 text-center text-sm text-slate-600">{footer}</p>}
        </div>
      </div>
      <BrandPanel />
    </div>
  )
}

/** Decorative product preview drawn with CSS, so no external images are needed. */
function BrandPanel() {
  const columns = [
    { name: 'To do', cards: [['bg-violet-400', 'w-3/4'], ['bg-sky-400', 'w-1/2'], ['bg-amber-400', 'w-2/3']] },
    { name: 'In progress', cards: [['bg-emerald-400', 'w-2/3'], ['bg-pink-400', 'w-4/5']] },
    { name: 'Done', cards: [['bg-indigo-400', 'w-1/2']] },
  ]
  return (
    <div
      className="relative hidden overflow-hidden lg:flex lg:flex-col lg:justify-center lg:px-16"
      style={{ background: 'linear-gradient(135deg, #4f46e5 0%, #7c3aed 50%, #c026d3 100%)' }}
    >
      <div className="absolute -top-24 -right-24 size-96 rounded-full bg-white/10 blur-3xl" />
      <div className="absolute -bottom-32 -left-16 size-96 rounded-full bg-fuchsia-300/20 blur-3xl" />
      <div className="relative">
        <h2 className="max-w-md text-3xl font-semibold tracking-tight text-white">
          Plan, track and ship work together.
        </h2>
        <p className="mt-3 max-w-md text-indigo-100">
          Boards, lists and cards that keep your whole team in sync, from the first idea to done.
        </p>
        <div className="mt-10 flex gap-4" aria-hidden="true">
          {columns.map((column) => (
            <div key={column.name} className="w-44 rounded-xl bg-white/15 p-3 backdrop-blur-sm">
              <p className="mb-3 text-xs font-semibold text-white/90">{column.name}</p>
              <div className="space-y-2">
                {column.cards.map(([color, width], index) => (
                  <div key={index} className="rounded-lg bg-white p-2.5 shadow-sm">
                    <div className={`mb-2 h-1.5 w-8 rounded-full ${color}`} />
                    <div className={`h-2 rounded bg-slate-200 ${width}`} />
                    <div className="mt-1.5 h-2 w-1/3 rounded bg-slate-100" />
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
