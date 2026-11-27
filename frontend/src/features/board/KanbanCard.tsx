import { useSortable } from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'
import { AlignLeft, Calendar, CircleCheck, MessageSquare, SquareCheckBig } from 'lucide-react'
import { Avatar } from '@/components/Avatar'
import { cardKey } from '@/lib/board-state'
import { labelColor, PRIORITIES } from '@/lib/theme'
import type { CardSummary, Label } from '@/lib/types'
import { cn, dueState, formatShortDate } from '@/lib/utils'

interface KanbanCardProps {
  card: CardSummary
  labels: Label[]
  disabled: boolean
  onOpen: (cardId: number) => void
}

export function KanbanCard({ card, labels, disabled, onOpen }: KanbanCardProps) {
  const { setNodeRef, attributes, listeners, transform, transition, isDragging } = useSortable({
    id: cardKey(card.id),
    disabled,
  })

  return (
    <div
      ref={setNodeRef}
      style={{ transform: CSS.Translate.toString(transform), transition }}
      {...attributes}
      {...listeners}
      aria-label={`Card: ${card.title}`}
      onClick={() => onOpen(card.id)}
      onKeyDown={(event) => {
        if (event.key === 'Enter') onOpen(card.id)
      }}
      className={cn('touch-manipulation rounded-lg outline-none', isDragging && 'opacity-40')}
    >
      <CardPreview card={card} labels={labels} />
    </div>
  )
}

/** Presentational card, shared by the board and the drag overlay. */
export function CardPreview({ card, labels, overlay = false }: { card: CardSummary; labels: Label[]; overlay?: boolean }) {
  const cardLabels = card.labelIds
    .map((id) => labels.find((label) => label.id === id))
    .filter((label): label is Label => Boolean(label))
  const due = card.dueDate ? dueState(card.dueDate, card.completed) : null
  const checklistComplete = card.checklistTotal > 0 && card.checklistDone === card.checklistTotal

  return (
    <article
      className={cn(
        'group cursor-pointer rounded-lg border border-slate-200/80 bg-white p-3 shadow-sm transition hover:border-brand-500/40 hover:shadow-md',
        overlay && 'rotate-2 cursor-grabbing shadow-xl ring-2 ring-brand-500/40',
      )}
    >
      {cardLabels.length > 0 && (
        <div className="mb-2 flex flex-wrap gap-1">
          {cardLabels.map((label) => (
            <span
              key={label.id}
              className="rounded px-1.5 py-0.5 text-[11px] leading-none font-semibold"
              style={{ backgroundColor: labelColor(label.color).bg, color: labelColor(label.color).fg }}
            >
              {label.name}
            </span>
          ))}
        </div>
      )}

      <p className={cn('text-sm leading-snug text-slate-800', card.completed && 'text-slate-500 line-through')}>
        {card.completed && <CircleCheck className="mr-1 -mt-0.5 inline size-4 text-emerald-600" />}
        {card.title}
      </p>

      <div className="mt-2.5 flex flex-wrap items-center gap-x-3 gap-y-1.5 text-xs text-slate-500 empty:hidden">
        {card.priority !== 'NONE' && (
          <span className={cn('rounded px-1.5 py-0.5 font-medium', PRIORITIES[card.priority].className)}>
            {PRIORITIES[card.priority].label}
          </span>
        )}
        {card.dueDate && (
          <span
            className={cn(
              'inline-flex items-center gap-1 rounded px-1.5 py-0.5',
              due === 'overdue' && 'bg-red-100 font-medium text-red-700',
              due === 'soon' && 'bg-amber-100 font-medium text-amber-800',
              due === 'done' && 'bg-emerald-100 text-emerald-700',
            )}
            title="Due date"
          >
            <Calendar className="size-3.5" />
            {formatShortDate(card.dueDate)}
          </span>
        )}
        {card.hasDescription && <AlignLeft className="size-3.5" aria-label="Has description" />}
        {card.checklistTotal > 0 && (
          <span
            className={cn(
              'inline-flex items-center gap-1',
              checklistComplete && 'rounded bg-emerald-100 px-1.5 py-0.5 text-emerald-700',
            )}
            title="Checklist"
          >
            <SquareCheckBig className="size-3.5" />
            {card.checklistDone}/{card.checklistTotal}
          </span>
        )}
        {card.commentCount > 0 && (
          <span className="inline-flex items-center gap-1" title="Comments">
            <MessageSquare className="size-3.5" />
            {card.commentCount}
          </span>
        )}
        {card.assignee && <Avatar user={card.assignee} size="xs" className="ml-auto ring-0" />}
      </div>
    </article>
  )
}
