import { Check } from 'lucide-react'
import { BACKGROUNDS } from '@/lib/theme'
import { cn } from '@/lib/utils'

export function BackgroundPicker({ value, onChange }: { value: string; onChange: (key: string) => void }) {
  return (
    <div className="grid grid-cols-4 gap-2" role="radiogroup" aria-label="Board background">
      {Object.entries(BACKGROUNDS).map(([key, { name, gradient }]) => (
        <button
          key={key}
          type="button"
          role="radio"
          aria-checked={value === key}
          title={name}
          onClick={() => onChange(key)}
          className={cn(
            'relative flex h-12 items-center justify-center rounded-lg transition hover:brightness-110',
            value === key && 'ring-2 ring-slate-900 ring-offset-2',
          )}
          style={{ background: gradient }}
        >
          {value === key && <Check className="size-5 text-white drop-shadow" />}
          <span className="sr-only">{name}</span>
        </button>
      ))}
    </div>
  )
}
