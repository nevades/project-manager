import {
  AlignLeft,
  Calendar,
  CircleCheck,
  Flag,
  MessageSquare,
  SquareCheckBig,
  Tag,
  Trash2,
  UserRound,
  X,
} from 'lucide-react'
import { useEffect, useState, type FormEvent, type ReactNode } from 'react'
import { Avatar } from '@/components/Avatar'
import { ConfirmDialog } from '@/components/ConfirmDialog'
import { Modal } from '@/components/Modal'
import { Spinner } from '@/components/Spinner'
import {
  useAddChecklistItem,
  useAddComment,
  useCard,
  useDeleteCard,
  useDeleteChecklistItem,
  useDeleteComment,
  useMe,
  useUpdateCard,
  useUpdateChecklistItem,
} from '@/lib/queries'
import { labelColor, PRIORITIES, PRIORITY_ORDER } from '@/lib/theme'
import type { BoardDetail, CardDetail, Priority, UpdateCardInput } from '@/lib/types'
import { cn, formatDateTime, relativeTime } from '@/lib/utils'

interface CardModalProps {
  board: BoardDetail
  cardId: number
  onClose: () => void
}

export function CardModal({ board, cardId, onClose }: CardModalProps) {
  const { data: card, isPending, error } = useCard(cardId)

  return (
    <Modal open onClose={onClose} size="xl" bare>
      {isPending && (
        <div className="flex justify-center p-16 text-slate-400">
          <Spinner className="size-8" />
        </div>
      )}
      {error && (
        <div className="p-8 text-center">
          <p className="text-slate-700">This card could not be loaded. It may have been deleted.</p>
          <button type="button" className="btn-secondary mt-4" onClick={onClose}>
            Close
          </button>
        </div>
      )}
      {card && <CardEditor board={board} card={card} onClose={onClose} />}
    </Modal>
  )
}

function toInput(card: CardDetail): UpdateCardInput {
  return {
    title: card.title,
    description: card.description,
    priority: card.priority,
    dueDate: card.dueDate,
    assigneeId: card.assignee?.id ?? null,
    completed: card.completed,
    labelIds: card.labelIds,
  }
}

function CardEditor({ board, card, onClose }: { board: BoardDetail; card: CardDetail; onClose: () => void }) {
  const updateCard = useUpdateCard(board.id, card.id)
  const deleteCard = useDeleteCard(board.id)
  const [confirmDelete, setConfirmDelete] = useState(false)

  const save = (patch: Partial<UpdateCardInput>) => updateCard.mutate({ ...toInput(card), ...patch })

  const toggleLabel = (labelId: number) =>
    save({
      labelIds: card.labelIds.includes(labelId)
        ? card.labelIds.filter((id) => id !== labelId)
        : [...card.labelIds, labelId],
    })

  const cardLabels = board.labels.filter((label) => card.labelIds.includes(label.id))

  return (
    <div className="relative">
      <button type="button" onClick={onClose} className="btn-ghost absolute top-3 right-3 p-1.5" aria-label="Close">
        <X className="size-5" />
      </button>

      <div className="border-b border-slate-100 px-6 pt-6 pb-4 pr-14">
        <TitleEditor title={card.title} onSave={(title) => save({ title })} />
        <p className="mt-1 text-sm text-slate-500">
          in list <span className="font-medium text-slate-700">{card.listName}</span>
          {updateCard.isPending && <Spinner className="ml-2 inline size-3.5" />}
        </p>
      </div>

      <div className="grid gap-8 p-6 md:grid-cols-[1fr_15rem]">
        <div className="min-w-0 space-y-8">
          {(cardLabels.length > 0 || card.priority !== 'NONE' || card.completed) && (
            <div className="flex flex-wrap items-center gap-2">
              {card.completed && (
                <span className="inline-flex items-center gap-1 rounded-md bg-emerald-100 px-2 py-1 text-xs font-semibold text-emerald-700">
                  <CircleCheck className="size-3.5" /> Complete
                </span>
              )}
              {card.priority !== 'NONE' && (
                <span className={cn('rounded-md px-2 py-1 text-xs font-semibold', PRIORITIES[card.priority].className)}>
                  {PRIORITIES[card.priority].label} priority
                </span>
              )}
              {cardLabels.map((label) => (
                <span
                  key={label.id}
                  className="rounded-md px-2 py-1 text-xs font-semibold"
                  style={{ backgroundColor: labelColor(label.color).bg, color: labelColor(label.color).fg }}
                >
                  {label.name}
                </span>
              ))}
            </div>
          )}

          <Section icon={<AlignLeft className="size-4" />} title="Description">
            <DescriptionEditor description={card.description} onSave={(description) => save({ description })} />
          </Section>

          <Section icon={<SquareCheckBig className="size-4" />} title="Checklist">
            <Checklist boardId={board.id} card={card} />
          </Section>

          <Section icon={<MessageSquare className="size-4" />} title="Activity">
            <Comments boardId={board.id} card={card} />
          </Section>
        </div>

        <aside className="space-y-5">
          <SidebarField label="Status" icon={<CircleCheck className="size-3.5" />}>
            <button
              type="button"
              onClick={() => save({ completed: !card.completed })}
              className={cn(
                'w-full',
                card.completed ? 'btn-primary bg-emerald-600 hover:bg-emerald-700' : 'btn-secondary',
              )}
            >
              <CircleCheck className="size-4" />
              {card.completed ? 'Completed' : 'Mark complete'}
            </button>
          </SidebarField>

          <SidebarField label="Assignee" icon={<UserRound className="size-3.5" />} htmlFor="card-assignee">
            <select
              id="card-assignee"
              className="input"
              value={card.assignee?.id ?? ''}
              onChange={(event) => save({ assigneeId: event.target.value ? Number(event.target.value) : null })}
            >
              <option value="">Unassigned</option>
              {board.members.map((member) => (
                <option key={member.id} value={member.id}>
                  {member.displayName}
                </option>
              ))}
            </select>
          </SidebarField>

          <SidebarField label="Priority" icon={<Flag className="size-3.5" />} htmlFor="card-priority">
            <select
              id="card-priority"
              className="input"
              value={card.priority}
              onChange={(event) => save({ priority: event.target.value as Priority })}
            >
              {PRIORITY_ORDER.map((priority) => (
                <option key={priority} value={priority}>
                  {PRIORITIES[priority].label}
                </option>
              ))}
            </select>
          </SidebarField>

          <SidebarField label="Due date" icon={<Calendar className="size-3.5" />} htmlFor="card-due">
            <div className="flex gap-1">
              <input
                id="card-due"
                type="date"
                className="input"
                value={card.dueDate ?? ''}
                onChange={(event) => save({ dueDate: event.target.value || null })}
              />
              {card.dueDate && (
                <button
                  type="button"
                  className="btn-ghost p-2"
                  aria-label="Clear due date"
                  onClick={() => save({ dueDate: null })}
                >
                  <X className="size-4" />
                </button>
              )}
            </div>
          </SidebarField>

          <SidebarField label="Labels" icon={<Tag className="size-3.5" />}>
            {board.labels.length === 0 ? (
              <p className="text-xs text-slate-500">Create labels in board settings.</p>
            ) : (
              <div className="flex flex-wrap gap-1.5">
                {board.labels.map((label) => {
                  const selected = card.labelIds.includes(label.id)
                  return (
                    <button
                      key={label.id}
                      type="button"
                      aria-pressed={selected}
                      onClick={() => toggleLabel(label.id)}
                      className={cn(
                        'rounded-md px-2 py-1 text-xs font-semibold transition',
                        !selected && 'opacity-40 hover:opacity-80',
                      )}
                      style={{ backgroundColor: labelColor(label.color).bg, color: labelColor(label.color).fg }}
                    >
                      {label.name}
                    </button>
                  )
                })}
              </div>
            )}
          </SidebarField>

          <div className="border-t border-slate-100 pt-5 text-xs text-slate-500">
            <p>
              Created by {card.createdBy.displayName}
              <br />
              {formatDateTime(card.createdAt)}
            </p>
            <button
              type="button"
              className="btn-ghost mt-4 w-full justify-start px-2 text-red-600 hover:bg-red-50 hover:text-red-700"
              onClick={() => setConfirmDelete(true)}
            >
              <Trash2 className="size-4" />
              Delete card
            </button>
          </div>
        </aside>
      </div>

      <ConfirmDialog
        open={confirmDelete}
        title="Delete card?"
        pending={deleteCard.isPending}
        onClose={() => setConfirmDelete(false)}
        onConfirm={() => deleteCard.mutate(card.id, { onSuccess: onClose })}
      >
        <strong>{card.title}</strong> will be permanently deleted, along with its checklist and comments.
      </ConfirmDialog>
    </div>
  )
}

function Section({ icon, title, children }: { icon: ReactNode; title: string; children: ReactNode }) {
  return (
    <section>
      <h3 className="mb-3 flex items-center gap-2 text-sm font-semibold text-slate-900">
        <span className="text-slate-500">{icon}</span>
        {title}
      </h3>
      {children}
    </section>
  )
}

function SidebarField({
  label,
  icon,
  htmlFor,
  children,
}: {
  label: string
  icon: ReactNode
  htmlFor?: string
  children: ReactNode
}) {
  const heading = (
    <>
      {icon}
      {label}
    </>
  )
  return (
    <div>
      {htmlFor ? (
        <label htmlFor={htmlFor} className="section-title">
          {heading}
        </label>
      ) : (
        <p className="section-title">{heading}</p>
      )}
      {children}
    </div>
  )
}

function TitleEditor({ title, onSave }: { title: string; onSave: (title: string) => void }) {
  const [value, setValue] = useState(title)
  useEffect(() => setValue(title), [title])

  const commit = () => {
    const trimmed = value.trim()
    if (trimmed && trimmed !== title) onSave(trimmed)
    else setValue(title)
  }

  return (
    <textarea
      aria-label="Card title"
      rows={1}
      maxLength={255}
      value={value}
      onChange={(event) => setValue(event.target.value)}
      onBlur={commit}
      onKeyDown={(event) => {
        if (event.key === 'Enter') {
          event.preventDefault()
          event.currentTarget.blur()
        }
      }}
      className="field-sizing-content w-full resize-none rounded-md border border-transparent px-1 py-0.5 -ml-1 text-xl font-semibold text-slate-900 hover:border-slate-200 focus:border-brand-500 focus:outline-none"
    />
  )
}

function DescriptionEditor({
  description,
  onSave,
}: {
  description: string | null
  onSave: (description: string | null) => void
}) {
  const [editing, setEditing] = useState(false)
  const [value, setValue] = useState(description ?? '')

  useEffect(() => {
    if (!editing) setValue(description ?? '')
  }, [description, editing])

  if (!editing) {
    return (
      <button
        type="button"
        onClick={() => setEditing(true)}
        className={cn(
          'w-full rounded-lg px-3 py-2.5 text-left text-sm whitespace-pre-wrap transition',
          description ? 'text-slate-700 hover:bg-slate-50' : 'bg-slate-100 text-slate-500 hover:bg-slate-200',
        )}
      >
        {description || 'Add a more detailed description…'}
      </button>
    )
  }

  return (
    <div className="space-y-2">
      <textarea
        autoFocus
        rows={6}
        maxLength={10000}
        className="input"
        value={value}
        onChange={(event) => setValue(event.target.value)}
        placeholder="Add a more detailed description…"
      />
      <div className="flex gap-2">
        <button
          type="button"
          className="btn-primary py-1.5"
          onClick={() => {
            onSave(value.trim() ? value : null)
            setEditing(false)
          }}
        >
          Save
        </button>
        <button type="button" className="btn-ghost py-1.5" onClick={() => setEditing(false)}>
          Cancel
        </button>
      </div>
    </div>
  )
}

function Checklist({ boardId, card }: { boardId: number; card: CardDetail }) {
  const [content, setContent] = useState('')
  const addItem = useAddChecklistItem(boardId, card.id)
  const updateItem = useUpdateChecklistItem(boardId, card.id)
  const deleteItem = useDeleteChecklistItem(boardId, card.id)

  const total = card.checklist.length
  const done = card.checklist.filter((item) => item.done).length
  const percent = total === 0 ? 0 : Math.round((done / total) * 100)

  const onSubmit = (event: FormEvent) => {
    event.preventDefault()
    if (!content.trim()) return
    addItem.mutate(content.trim(), { onSuccess: () => setContent('') })
  }

  return (
    <div className="space-y-3">
      {total > 0 && (
        <div className="flex items-center gap-3">
          <span className="w-9 text-xs font-medium text-slate-500">{percent}%</span>
          <div className="h-2 flex-1 overflow-hidden rounded-full bg-slate-100">
            <div
              className={cn('h-full rounded-full transition-all', percent === 100 ? 'bg-emerald-500' : 'bg-brand-500')}
              style={{ width: `${percent}%` }}
            />
          </div>
        </div>
      )}
      <ul className="space-y-1">
        {card.checklist.map((item) => (
          <li key={item.id} className="group flex items-center gap-3 rounded-lg px-2 py-1.5 hover:bg-slate-50">
            <input
              type="checkbox"
              className="size-4 rounded accent-brand-600"
              checked={item.done}
              aria-label={item.content}
              onChange={() => updateItem.mutate({ ...item, done: !item.done })}
            />
            <span className={cn('flex-1 text-sm', item.done ? 'text-slate-400 line-through' : 'text-slate-700')}>
              {item.content}
            </span>
            <button
              type="button"
              aria-label={`Delete ${item.content}`}
              className="rounded p-1 text-slate-400 opacity-0 group-hover:opacity-100 hover:text-red-600 focus:opacity-100"
              onClick={() => deleteItem.mutate(item.id)}
            >
              <Trash2 className="size-3.5" />
            </button>
          </li>
        ))}
      </ul>
      <form onSubmit={onSubmit} className="flex gap-2">
        <input
          className="input"
          placeholder="Add an item"
          aria-label="New checklist item"
          maxLength={500}
          value={content}
          onChange={(event) => setContent(event.target.value)}
        />
        <button type="submit" className="btn-secondary shrink-0" disabled={!content.trim() || addItem.isPending}>
          Add
        </button>
      </form>
    </div>
  )
}

function Comments({ boardId, card }: { boardId: number; card: CardDetail }) {
  const { data: me } = useMe()
  const [body, setBody] = useState('')
  const addComment = useAddComment(boardId, card.id)
  const deleteComment = useDeleteComment(boardId, card.id)

  const onSubmit = (event: FormEvent) => {
    event.preventDefault()
    if (!body.trim()) return
    addComment.mutate(body.trim(), { onSuccess: () => setBody('') })
  }

  return (
    <div className="space-y-4">
      {me && (
        <form onSubmit={onSubmit} className="flex gap-3">
          <Avatar user={me} />
          <div className="flex-1 space-y-2">
            <textarea
              rows={2}
              maxLength={5000}
              className="input resize-none"
              placeholder="Write a comment…"
              aria-label="Write a comment"
              value={body}
              onChange={(event) => setBody(event.target.value)}
              onKeyDown={(event) => {
                if (event.key === 'Enter' && (event.metaKey || event.ctrlKey)) onSubmit(event)
              }}
            />
            {body.trim() && (
              <button type="submit" className="btn-primary py-1.5" disabled={addComment.isPending}>
                Comment
              </button>
            )}
          </div>
        </form>
      )}
      <ul className="space-y-4">
        {card.comments.map((comment) => (
          <li key={comment.id} className="flex gap-3">
            <Avatar user={comment.author} />
            <div className="min-w-0 flex-1">
              <p className="text-sm">
                <span className="font-semibold text-slate-900">{comment.author.displayName}</span>{' '}
                <time dateTime={comment.createdAt} title={formatDateTime(comment.createdAt)} className="text-xs text-slate-500">
                  {relativeTime(comment.createdAt)}
                </time>
              </p>
              <p className="mt-1 rounded-lg bg-white px-3 py-2 text-sm whitespace-pre-wrap text-slate-700 shadow-sm ring-1 ring-slate-200">
                {comment.body}
              </p>
              {comment.author.id === me?.id && (
                <button
                  type="button"
                  className="mt-1 text-xs text-slate-500 underline-offset-2 hover:text-red-600 hover:underline"
                  onClick={() => deleteComment.mutate(comment.id)}
                >
                  Delete
                </button>
              )}
            </div>
          </li>
        ))}
      </ul>
    </div>
  )
}
