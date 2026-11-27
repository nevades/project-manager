import type { ReactNode } from 'react'
import { Modal } from './Modal'
import { Spinner } from './Spinner'

interface ConfirmDialogProps {
  open: boolean
  title: string
  children: ReactNode
  confirmLabel?: string
  pending?: boolean
  onConfirm: () => void
  onClose: () => void
}

export function ConfirmDialog({
  open,
  title,
  children,
  confirmLabel = 'Delete',
  pending = false,
  onConfirm,
  onClose,
}: ConfirmDialogProps) {
  return (
    <Modal open={open} onClose={onClose} title={title} size="sm">
      <div className="p-6">
        <div className="text-sm text-slate-600">{children}</div>
        <div className="mt-6 flex justify-end gap-2">
          <button type="button" className="btn-secondary" onClick={onClose}>
            Cancel
          </button>
          <button type="button" className="btn-danger" onClick={onConfirm} disabled={pending}>
            {pending && <Spinner className="size-4" />}
            {confirmLabel}
          </button>
        </div>
      </div>
    </Modal>
  )
}
