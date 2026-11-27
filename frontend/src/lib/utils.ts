import { clsx, type ClassValue } from 'clsx'

export function cn(...classes: ClassValue[]): string {
  return clsx(classes)
}

export function initials(name: string): string {
  const parts = name.trim().split(/\s+/).filter(Boolean)
  const letters = parts.length > 1 ? parts[0][0] + parts[parts.length - 1][0] : (parts[0] ?? '?').slice(0, 2)
  return letters.toUpperCase()
}

const AVATAR_COLORS = ['#6366f1', '#0ea5e9', '#10b981', '#f59e0b', '#ef4444', '#ec4899', '#8b5cf6', '#14b8a6']

/** Stable colour per user so avatars are recognisable across the app. */
export function avatarColor(id: number): string {
  return AVATAR_COLORS[Math.abs(id) % AVATAR_COLORS.length]
}

/** Parses a yyyy-MM-dd date as a local date (avoids the UTC shift of `new Date('2024-01-31')`). */
export function parseLocalDate(value: string): Date {
  const [year, month, day] = value.split('-').map(Number)
  return new Date(year, month - 1, day)
}

export type DueState = 'overdue' | 'soon' | 'later' | 'done'

export function dueState(dueDate: string, completed: boolean, today = new Date()): DueState {
  if (completed) return 'done'
  const startOfToday = new Date(today.getFullYear(), today.getMonth(), today.getDate())
  const days = Math.round((parseLocalDate(dueDate).getTime() - startOfToday.getTime()) / 86_400_000)
  if (days < 0) return 'overdue'
  if (days <= 2) return 'soon'
  return 'later'
}

const shortDate = new Intl.DateTimeFormat(undefined, { month: 'short', day: 'numeric' })
const dateTime = new Intl.DateTimeFormat(undefined, { dateStyle: 'medium', timeStyle: 'short' })

export function formatShortDate(value: string): string {
  return shortDate.format(parseLocalDate(value))
}

export function formatDateTime(value: string): string {
  return dateTime.format(new Date(value))
}

export function relativeTime(value: string, now = Date.now()): string {
  const seconds = Math.round((now - new Date(value).getTime()) / 1000)
  if (seconds < 60) return 'just now'
  const minutes = Math.round(seconds / 60)
  if (minutes < 60) return `${minutes}m ago`
  const hours = Math.round(minutes / 60)
  if (hours < 24) return `${hours}h ago`
  const days = Math.round(hours / 24)
  if (days < 7) return `${days}d ago`
  return formatDateTime(value)
}
