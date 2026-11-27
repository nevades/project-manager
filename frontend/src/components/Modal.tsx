import { X } from 'lucide-react'
import { useEffect, useId, type ReactNode } from 'react'
import { createPortal } from 'react-dom'
import { cn } from '@/lib/utils'

interface ModalProps {
  open: boolean
  onClose: () => void
  title?: ReactNode
  children: ReactNode
  size?: 'sm' | 'md' | 'lg' | 'xl'
  /** Hide the default header (for layouts that render their own title). */
  bare?: boolean
}

const SIZES = {
  sm: 'max-w-sm',
  md: 'max-w-lg',
  lg: 'max-w-2xl',
  xl: 'max-w-4xl',
}

export function Modal({ open, onClose, title, children, size = 'md', bare = false }: ModalProps) {
  const titleId = useId()

  useEffect(() => {
    if (!open) return
    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') onClose()
    }
    const previousOverflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    window.addEventListener('keydown', onKeyDown)
    return () => {
      document.body.style.overflow = previousOverflow
      window.removeEventListener('keydown', onKeyDown)
    }
  }, [open, onClose])

  if (!open) return null

  return createPortal(
    <div className="fixed inset-0 z-50 flex items-start justify-center overflow-y-auto p-4 sm:p-8">
      <div className="fixed inset-0 bg-slate-950/50 backdrop-blur-[2px]" onClick={onClose} aria-hidden="true" />
      <div
        role="dialog"
        aria-modal="true"
        aria-labelledby={title ? titleId : undefined}
        className={cn('relative my-auto w-full rounded-2xl bg-white shadow-2xl ring-1 ring-slate-900/5', SIZES[size])}
      >
        {!bare && (
          <div className="flex items-center justify-between border-b border-slate-100 px-6 py-4">
            <h2 id={titleId} className="text-base font-semibold text-slate-900">
              {title}
            </h2>
            <button type="button" onClick={onClose} className="btn-ghost -mr-2 p-1.5" aria-label="Close">
              <X className="size-5" />
            </button>
          </div>
        )}
        {children}
      </div>
    </div>,
    document.body,
  )
}
