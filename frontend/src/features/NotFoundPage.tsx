import { Link } from 'react-router'

export function NotFoundPage() {
  return (
    <div className="mx-auto flex max-w-md flex-col items-center px-6 py-24 text-center">
      <p className="text-sm font-semibold text-brand-600">404</p>
      <h1 className="mt-2 text-2xl font-semibold text-slate-900">Page not found</h1>
      <p className="mt-2 text-slate-600">The page you are looking for does not exist or you no longer have access.</p>
      <Link to="/" className="btn-primary mt-6">
        Back to boards
      </Link>
    </div>
  )
}
