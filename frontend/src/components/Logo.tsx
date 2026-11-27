import { cn } from '@/lib/utils'

interface LogoProps {
  className?: string
  /** Use white text for dark or gradient backgrounds. */
  inverted?: boolean
  showText?: boolean
}

export function LogoMark({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 32 32" aria-hidden="true" className={cn('size-8 shrink-0', className)}>
      <defs>
        <linearGradient id="tasklane-logo" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#6366f1" />
          <stop offset="1" stopColor="#a855f7" />
        </linearGradient>
      </defs>
      <rect width="32" height="32" rx="8" fill="url(#tasklane-logo)" />
      <rect x="7" y="7" width="5" height="18" rx="2" fill="#fff" />
      <rect x="13.5" y="7" width="5" height="12" rx="2" fill="#fff" fillOpacity=".85" />
      <rect x="20" y="7" width="5" height="7" rx="2" fill="#fff" fillOpacity=".7" />
    </svg>
  )
}

export function Logo({ className, inverted = false, showText = true }: LogoProps) {
  return (
    <span className={cn('inline-flex items-center gap-2.5', className)}>
      <LogoMark />
      {showText && (
        <span className={cn('text-lg font-semibold tracking-tight', inverted ? 'text-white' : 'text-slate-900')}>
          Tasklane
        </span>
      )}
    </span>
  )
}
