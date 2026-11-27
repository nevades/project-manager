import type { Priority } from './types'

/** Board background presets. The key is stored on the board; the gradient is applied client-side. */
export const BACKGROUNDS: Record<string, { name: string; gradient: string }> = {
  ocean: { name: 'Ocean', gradient: 'linear-gradient(135deg, #0ea5e9 0%, #4f46e5 100%)' },
  grape: { name: 'Grape', gradient: 'linear-gradient(135deg, #8b5cf6 0%, #c026d3 100%)' },
  sunset: { name: 'Sunset', gradient: 'linear-gradient(135deg, #f97316 0%, #db2777 100%)' },
  forest: { name: 'Forest', gradient: 'linear-gradient(135deg, #10b981 0%, #0f766e 100%)' },
  aurora: { name: 'Aurora', gradient: 'linear-gradient(135deg, #22d3ee 0%, #6366f1 50%, #a855f7 100%)' },
  peach: { name: 'Peach', gradient: 'linear-gradient(135deg, #fb7185 0%, #f59e0b 100%)' },
  slate: { name: 'Slate', gradient: 'linear-gradient(135deg, #475569 0%, #0f172a 100%)' },
  midnight: { name: 'Midnight', gradient: 'linear-gradient(135deg, #312e81 0%, #020617 100%)' },
}

export const DEFAULT_BACKGROUND = 'ocean'

export function backgroundOf(key: string): string {
  return (BACKGROUNDS[key] ?? BACKGROUNDS[DEFAULT_BACKGROUND]).gradient
}

/** Label colours accepted by the API, with readable foreground colours. */
export const LABEL_COLORS: Record<string, { bg: string; fg: string }> = {
  green: { bg: '#22c55e', fg: '#052e16' },
  lime: { bg: '#a3e635', fg: '#1a2e05' },
  yellow: { bg: '#facc15', fg: '#422006' },
  orange: { bg: '#fb923c', fg: '#431407' },
  red: { bg: '#ef4444', fg: '#ffffff' },
  pink: { bg: '#ec4899', fg: '#ffffff' },
  purple: { bg: '#a855f7', fg: '#ffffff' },
  blue: { bg: '#3b82f6', fg: '#ffffff' },
  sky: { bg: '#38bdf8', fg: '#082f49' },
  gray: { bg: '#94a3b8', fg: '#0f172a' },
}

export function labelColor(color: string) {
  return LABEL_COLORS[color] ?? LABEL_COLORS.gray
}

export const PRIORITIES: Record<Priority, { label: string; className: string }> = {
  NONE: { label: 'No priority', className: 'bg-slate-100 text-slate-600' },
  LOW: { label: 'Low', className: 'bg-emerald-100 text-emerald-700' },
  MEDIUM: { label: 'Medium', className: 'bg-amber-100 text-amber-800' },
  HIGH: { label: 'High', className: 'bg-orange-100 text-orange-700' },
  URGENT: { label: 'Urgent', className: 'bg-red-100 text-red-700' },
}

export const PRIORITY_ORDER: Priority[] = ['NONE', 'LOW', 'MEDIUM', 'HIGH', 'URGENT']
