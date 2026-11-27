/**
 * Thin fetch wrapper for the Tasklane API.
 *
 * Authentication uses the session cookie set by the backend. Mutating requests send the CSRF token from the
 * XSRF-TOKEN cookie in the X-XSRF-TOKEN header, fetching a token first if none exists yet.
 */

export class ApiError extends Error {
  readonly status: number

  constructor(status: number, message: string) {
    super(message)
    this.name = 'ApiError'
    this.status = status
  }
}

type Method = 'GET' | 'POST' | 'PUT' | 'DELETE'

const CSRF_COOKIE = 'XSRF-TOKEN'
const CSRF_HEADER = 'X-XSRF-TOKEN'

function readCookie(name: string): string | null {
  const match = document.cookie.split('; ').find((part) => part.startsWith(`${name}=`))
  return match ? decodeURIComponent(match.slice(name.length + 1)) : null
}

async function ensureCsrfToken(force = false): Promise<string | null> {
  if (!force) {
    const existing = readCookie(CSRF_COOKIE)
    if (existing) return existing
  }
  await fetch('/api/auth/csrf', { credentials: 'same-origin' })
  return readCookie(CSRF_COOKIE)
}

async function errorMessage(response: Response): Promise<string> {
  try {
    const problem = await response.json()
    if (typeof problem?.detail === 'string' && problem.detail) return problem.detail
  } catch {
    // Not JSON – fall through to a generic message.
  }
  if (response.status === 401) return 'Your session has expired. Please sign in again.'
  if (response.status === 403) return 'You do not have permission to do that.'
  return `Request failed (${response.status})`
}

async function request<T>(method: Method, url: string, body?: unknown, retried = false): Promise<T> {
  const headers: Record<string, string> = { Accept: 'application/json' }
  if (body !== undefined) headers['Content-Type'] = 'application/json'
  if (method !== 'GET') {
    const token = await ensureCsrfToken(retried)
    if (token) headers[CSRF_HEADER] = token
  }

  const response = await fetch(url, {
    method,
    headers,
    credentials: 'same-origin',
    body: body === undefined ? undefined : JSON.stringify(body),
  })

  // A stale CSRF token (for example after signing out) is refreshed and the request retried once.
  if (response.status === 403 && method !== 'GET' && !retried) {
    return request<T>(method, url, body, true)
  }

  if (!response.ok) {
    throw new ApiError(response.status, await errorMessage(response))
  }
  if (response.status === 204) return undefined as T

  const text = await response.text()
  return (text ? JSON.parse(text) : undefined) as T
}

export const api = {
  get: <T>(url: string) => request<T>('GET', url),
  post: <T>(url: string, body?: unknown) => request<T>('POST', url, body ?? {}),
  put: <T>(url: string, body?: unknown) => request<T>('PUT', url, body ?? {}),
  delete: <T = void>(url: string) => request<T>('DELETE', url),
}
