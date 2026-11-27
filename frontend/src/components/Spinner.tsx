import { LoaderCircle } from 'lucide-react'
import { cn } from '@/lib/utils'

export function Spinner({ className }: { className?: string }) {
  return <LoaderCircle className={cn('size-5 animate-spin', className)} aria-label="Loading" />
}

export function FullPageSpinner() {
  return (
    <div className="flex h-full items-center justify-center text-slate-400">
      <Spinner className="size-8" />
    </div>
  )
}
