import { SortableContext, useSortable, verticalListSortingStrategy } from '@dnd-kit/sortable'
import { CSS } from '@dnd-kit/utilities'
import { Ellipsis, Pencil, Plus, Trash2, X } from 'lucide-react'
import {
  useEffect,
  useRef,
  useState,
  type FormEvent,
  type KeyboardEvent,
  type MouseEvent,
  type PointerEvent,
  type TouchEvent,
} from 'react'
import { ConfirmDialog } from '@/components/ConfirmDialog'
import { cardKey, listKey } from '@/lib/board-state'
import { useCreateCard, useCreateList, useDeleteList, useRenameList } from '@/lib/queries'
import type { BoardListData, CardSummary, Label } from '@/lib/types'
import { cn } from '@/lib/utils'
import { KanbanCard } from './KanbanCard'

interface KanbanListProps {
  boardId: number
  list: BoardListData
  /** Cards to display; may be a filtered subset of `list.cards`. */
  cards: CardSummary[]
  labels: Label[]
  dragDisabled: boolean
  onOpenCard: (cardId: number) => void
}

/** Stops keyboard and pointer events from reaching the list's drag handle. */
const isolate = {
  onKeyDown: (event: KeyboardEvent) => event.stopPropagation(),
  onPointerDown: (event: PointerEvent) => event.stopPropagation(),
  onMouseDown: (event: MouseEvent) => event.stopPropagation(),
  onTouchStart: (event: TouchEvent) => event.stopPropagation(),
}

export function KanbanList({ boardId, list, cards, labels, dragDisabled, onOpenCard }: KanbanListProps) {
  const { setNodeRef, attributes, listeners, transform, transition, isDragging } = useSortable({
    id: listKey(list.id),
    disabled: dragDisabled,
  })
  const [renaming, setRenaming] = useState(false)
  const [menuOpen, setMenuOpen] = useState(false)
  const [confirmDelete, setConfirmDelete] = useState(false)
  const deleteList = useDeleteList(boardId)

  return (
    <section
      ref={setNodeRef}
      style={{ transform: CSS.Translate.toString(transform), transition }}
      aria-label={`List: ${list.name}`}
      className={cn(
        'flex max-h-full w-72 shrink-0 flex-col rounded-xl bg-slate-100/95 shadow-sm ring-1 ring-slate-900/5',
        isDragging && 'opacity-50',
      )}
    >
      <header
        {...attributes}
        {...listeners}
        className={cn('flex items-center gap-2 px-3 pt-3 pb-2', !dragDisabled && 'cursor-grab active:cursor-grabbing')}
      >
        {renaming ? (
          <RenameListInput boardId={boardId} list={list} onDone={() => setRenaming(false)} />
        ) : (
          <h3
            className="min-w-0 flex-1 truncate text-sm font-semibold text-slate-800"
            onDoubleClick={() => setRenaming(true)}
          >
            {list.name}
          </h3>
        )}
        <span className="rounded-full bg-slate-200 px-2 py-0.5 text-xs font-medium text-slate-600">
          {list.cards.length}
        </span>
        <div className="relative" {...isolate}>
          <button
            type="button"
            className="rounded-md p-1 text-slate-500 hover:bg-slate-200 hover:text-slate-800"
            aria-label={`List actions for ${list.name}`}
            aria-haspopup="menu"
            aria-expanded={menuOpen}
            onClick={() => setMenuOpen((open) => !open)}
          >
            <Ellipsis className="size-4" />
          </button>
          {menuOpen && (
            <>
              <div className="fixed inset-0 z-10" onClick={() => setMenuOpen(false)} aria-hidden="true" />
              <div role="menu" className="absolute right-0 z-20 mt-1 w-44 rounded-lg bg-white py-1 shadow-lg ring-1 ring-slate-900/10">
                <button
                  type="button"
                  role="menuitem"
                  className="flex w-full items-center gap-2 px-3 py-2 text-left text-sm text-slate-700 hover:bg-slate-50"
                  onClick={() => {
                    setMenuOpen(false)
                    setRenaming(true)
                  }}
                >
                  <Pencil className="size-4" /> Rename list
                </button>
                <button
                  type="button"
                  role="menuitem"
                  className="flex w-full items-center gap-2 px-3 py-2 text-left text-sm text-red-600 hover:bg-red-50"
                  onClick={() => {
                    setMenuOpen(false)
                    setConfirmDelete(true)
                  }}
                >
                  <Trash2 className="size-4" /> Delete list
                </button>
              </div>
            </>
          )}
        </div>
      </header>

      <SortableContext items={cards.map((card) => cardKey(card.id))} strategy={verticalListSortingStrategy}>
        <div className="scrollbar-thin-dark flex min-h-2 flex-1 flex-col gap-2 overflow-y-auto px-2 pb-1">
          {cards.map((card) => (
            <KanbanCard key={card.id} card={card} labels={labels} disabled={dragDisabled} onOpen={onOpenCard} />
          ))}
        </div>
      </SortableContext>

      <AddCardForm boardId={boardId} listId={list.id} />

      <ConfirmDialog
        open={confirmDelete}
        title="Delete list?"
        pending={deleteList.isPending}
        onClose={() => setConfirmDelete(false)}
        onConfirm={() => deleteList.mutate(list.id, { onSuccess: () => setConfirmDelete(false) })}
      >
        <strong>{list.name}</strong> and its {list.cards.length} card{list.cards.length === 1 ? '' : 's'} will be
        permanently deleted.
      </ConfirmDialog>
    </section>
  )
}

function RenameListInput({ boardId, list, onDone }: { boardId: number; list: BoardListData; onDone: () => void }) {
  const [name, setName] = useState(list.name)
  const renameList = useRenameList(boardId)

  const save = () => {
    const trimmed = name.trim()
    if (trimmed && trimmed !== list.name) renameList.mutate({ listId: list.id, name: trimmed })
    onDone()
  }

  return (
    <input
      autoFocus
      className="input min-w-0 flex-1 py-1 font-semibold"
      value={name}
      maxLength={120}
      aria-label="List name"
      onChange={(event) => setName(event.target.value)}
      onBlur={save}
      {...isolate}
      onKeyDown={(event) => {
        event.stopPropagation()
        if (event.key === 'Enter') save()
        if (event.key === 'Escape') onDone()
      }}
    />
  )
}

function AddCardForm({ boardId, listId }: { boardId: number; listId: number }) {
  const [open, setOpen] = useState(false)
  const [title, setTitle] = useState('')
  const createCard = useCreateCard(boardId)
  const textareaRef = useRef<HTMLTextAreaElement>(null)

  useEffect(() => {
    if (open) textareaRef.current?.focus()
  }, [open])

  const submit = (event?: FormEvent) => {
    event?.preventDefault()
    const trimmed = title.trim()
    if (!trimmed) return
    createCard.mutate({ listId, title: trimmed })
    setTitle('')
    textareaRef.current?.focus()
  }

  if (!open) {
    return (
      <button
        type="button"
        onClick={() => setOpen(true)}
        className="m-2 mt-1 flex items-center gap-1.5 rounded-lg px-2 py-1.5 text-left text-sm font-medium text-slate-600 hover:bg-slate-200/80 hover:text-slate-900"
      >
        <Plus className="size-4" />
        Add a card
      </button>
    )
  }

  return (
    <form onSubmit={submit} className="space-y-2 p-2">
      <textarea
        ref={textareaRef}
        rows={2}
        maxLength={255}
        className="input resize-none shadow"
        placeholder="Enter a title for this card…"
        value={title}
        onChange={(event) => setTitle(event.target.value)}
        onKeyDown={(event) => {
          if (event.key === 'Enter' && !event.shiftKey) submit(event)
          if (event.key === 'Escape') setOpen(false)
        }}
      />
      <div className="flex items-center gap-2">
        <button type="submit" className="btn-primary py-1.5" disabled={!title.trim()}>
          Add card
        </button>
        <button type="button" className="btn-ghost p-1.5" aria-label="Cancel" onClick={() => setOpen(false)}>
          <X className="size-4" />
        </button>
      </div>
    </form>
  )
}

export function AddListForm({ boardId }: { boardId: number }) {
  const [open, setOpen] = useState(false)
  const [name, setName] = useState('')
  const createList = useCreateList(boardId)

  const submit = (event: FormEvent) => {
    event.preventDefault()
    const trimmed = name.trim()
    if (!trimmed) return
    createList.mutate(trimmed, { onSuccess: () => setName('') })
  }

  if (!open) {
    return (
      <button
        type="button"
        onClick={() => setOpen(true)}
        className="flex w-72 shrink-0 items-center gap-2 rounded-xl bg-white/20 px-4 py-3 text-sm font-medium text-white backdrop-blur-sm transition hover:bg-white/30"
      >
        <Plus className="size-4" />
        Add another list
      </button>
    )
  }

  return (
    <form onSubmit={submit} className="w-72 shrink-0 space-y-2 rounded-xl bg-slate-100 p-2 shadow-sm">
      <input
        autoFocus
        className="input"
        placeholder="List name"
        maxLength={120}
        value={name}
        onChange={(event) => setName(event.target.value)}
        onKeyDown={(event) => event.key === 'Escape' && setOpen(false)}
      />
      <div className="flex items-center gap-2">
        <button type="submit" className="btn-primary py-1.5" disabled={!name.trim() || createList.isPending}>
          Add list
        </button>
        <button type="button" className="btn-ghost p-1.5" aria-label="Cancel" onClick={() => setOpen(false)}>
          <X className="size-4" />
        </button>
      </div>
    </form>
  )
}
