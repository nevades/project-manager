import { Check, Pencil, Plus, Trash2, X } from 'lucide-react'
import { useState, type FormEvent } from 'react'
import { useNavigate } from 'react-router'
import { Avatar } from '@/components/Avatar'
import { ConfirmDialog } from '@/components/ConfirmDialog'
import { Modal } from '@/components/Modal'
import { Spinner } from '@/components/Spinner'
import {
  useAddMember,
  useCreateLabel,
  useDeleteBoard,
  useDeleteLabel,
  useMe,
  useRemoveMember,
  useUpdateBoard,
  useUpdateLabel,
} from '@/lib/queries'
import { LABEL_COLORS, labelColor } from '@/lib/theme'
import type { BoardDetail, Label } from '@/lib/types'
import { cn } from '@/lib/utils'
import { BackgroundPicker } from '../boards/BackgroundPicker'

export type SettingsTab = 'general' | 'members' | 'labels'

const TABS: { id: SettingsTab; label: string }[] = [
  { id: 'general', label: 'General' },
  { id: 'members', label: 'Members' },
  { id: 'labels', label: 'Labels' },
]

interface BoardSettingsDialogProps {
  board: BoardDetail
  tab: SettingsTab | null
  onTabChange: (tab: SettingsTab) => void
  onClose: () => void
}

export function BoardSettingsDialog({ board, tab, onTabChange, onClose }: BoardSettingsDialogProps) {
  return (
    <Modal open={tab !== null} onClose={onClose} title="Board settings" size="lg">
      <div className="flex gap-1 border-b border-slate-100 px-6" role="tablist">
        {TABS.map(({ id, label }) => (
          <button
            key={id}
            type="button"
            role="tab"
            aria-selected={tab === id}
            onClick={() => onTabChange(id)}
            className={cn(
              '-mb-px border-b-2 px-3 py-2.5 text-sm font-medium transition',
              tab === id ? 'border-brand-600 text-brand-700' : 'border-transparent text-slate-500 hover:text-slate-800',
            )}
          >
            {label}
          </button>
        ))}
      </div>
      <div className="p-6">
        {tab === 'general' && <GeneralTab board={board} onClose={onClose} />}
        {tab === 'members' && <MembersTab board={board} />}
        {tab === 'labels' && <LabelsTab board={board} />}
      </div>
    </Modal>
  )
}

function GeneralTab({ board, onClose }: { board: BoardDetail; onClose: () => void }) {
  const isOwner = board.role === 'OWNER'
  const [name, setName] = useState(board.name)
  const [description, setDescription] = useState(board.description ?? '')
  const [background, setBackground] = useState(board.background)
  const [confirmDelete, setConfirmDelete] = useState(false)
  const updateBoard = useUpdateBoard(board.id)
  const deleteBoard = useDeleteBoard()
  const navigate = useNavigate()

  const onSubmit = (event: FormEvent) => {
    event.preventDefault()
    updateBoard.mutate({ name, description: description || null, background }, { onSuccess: onClose })
  }

  return (
    <>
      <form onSubmit={onSubmit} className="space-y-5">
        <fieldset disabled={!isOwner} className="space-y-5">
          <div>
            <label htmlFor="settings-name" className="label">
              Name
            </label>
            <input
              id="settings-name"
              className="input"
              required
              maxLength={120}
              value={name}
              onChange={(event) => setName(event.target.value)}
            />
          </div>
          <div>
            <label htmlFor="settings-description" className="label">
              Description
            </label>
            <textarea
              id="settings-description"
              className="input resize-none"
              rows={3}
              maxLength={2000}
              value={description}
              onChange={(event) => setDescription(event.target.value)}
            />
          </div>
          <div>
            <span className="label">Background</span>
            <BackgroundPicker value={background} onChange={(key) => isOwner && setBackground(key)} />
          </div>
        </fieldset>
        {isOwner ? (
          <div className="flex justify-end">
            <button type="submit" className="btn-primary" disabled={!name.trim() || updateBoard.isPending}>
              {updateBoard.isPending && <Spinner className="size-4" />}
              Save changes
            </button>
          </div>
        ) : (
          <p className="text-sm text-slate-500">Only the board owner can change these settings.</p>
        )}
      </form>

      {isOwner && (
        <div className="mt-8 rounded-xl border border-red-200 bg-red-50/50 p-4">
          <h3 className="text-sm font-semibold text-red-800">Delete this board</h3>
          <p className="mt-1 text-sm text-red-700">All lists, cards and comments will be permanently removed.</p>
          <button type="button" className="btn-danger mt-3" onClick={() => setConfirmDelete(true)}>
            <Trash2 className="size-4" />
            Delete board
          </button>
        </div>
      )}

      <ConfirmDialog
        open={confirmDelete}
        title="Delete board?"
        confirmLabel="Delete board"
        pending={deleteBoard.isPending}
        onClose={() => setConfirmDelete(false)}
        onConfirm={() => deleteBoard.mutate(board.id, { onSuccess: () => navigate('/', { replace: true }) })}
      >
        This will permanently delete <strong>{board.name}</strong> for every member. This cannot be undone.
      </ConfirmDialog>
    </>
  )
}

function MembersTab({ board }: { board: BoardDetail }) {
  const { data: me } = useMe()
  const isOwner = board.role === 'OWNER'
  const [email, setEmail] = useState('')
  const [leaving, setLeaving] = useState(false)
  const addMember = useAddMember(board.id)
  const removeMember = useRemoveMember(board.id)
  const navigate = useNavigate()

  const onSubmit = (event: FormEvent) => {
    event.preventDefault()
    addMember.mutate(email.trim(), { onSuccess: () => setEmail('') })
  }

  return (
    <div className="space-y-6">
      {isOwner && (
        <form onSubmit={onSubmit} className="flex gap-2">
          <label htmlFor="member-email" className="sr-only">
            Email address
          </label>
          <input
            id="member-email"
            type="email"
            required
            className="input"
            placeholder="Invite by email address"
            value={email}
            onChange={(event) => setEmail(event.target.value)}
          />
          <button type="submit" className="btn-primary shrink-0" disabled={addMember.isPending}>
            {addMember.isPending ? <Spinner className="size-4" /> : <Plus className="size-4" />}
            Add
          </button>
        </form>
      )}
      {isOwner && (
        <p className="-mt-4 text-xs text-slate-500">People need a Tasklane account before they can be added.</p>
      )}

      <ul className="divide-y divide-slate-100">
        {board.members.map((member) => (
          <li key={member.id} className="flex items-center gap-3 py-3">
            <Avatar user={member} />
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-medium text-slate-900">
                {member.displayName}
                {member.id === me?.id && <span className="ml-1 font-normal text-slate-500">(you)</span>}
              </p>
              <p className="truncate text-xs text-slate-500">{member.email}</p>
            </div>
            <span
              className={cn(
                'rounded-full px-2 py-0.5 text-xs font-medium',
                member.role === 'OWNER' ? 'bg-brand-50 text-brand-700' : 'bg-slate-100 text-slate-600',
              )}
            >
              {member.role === 'OWNER' ? 'Owner' : 'Member'}
            </span>
            {isOwner && member.role !== 'OWNER' && (
              <button
                type="button"
                className="btn-ghost p-1.5 text-slate-400 hover:text-red-600"
                aria-label={`Remove ${member.displayName}`}
                onClick={() => removeMember.mutate(member.id)}
              >
                <X className="size-4" />
              </button>
            )}
          </li>
        ))}
      </ul>

      {!isOwner && me && (
        <>
          <button type="button" className="btn-secondary text-red-600" onClick={() => setLeaving(true)}>
            Leave board
          </button>
          <ConfirmDialog
            open={leaving}
            title="Leave board?"
            confirmLabel="Leave"
            pending={removeMember.isPending}
            onClose={() => setLeaving(false)}
            onConfirm={() => removeMember.mutate(me.id, { onSuccess: () => navigate('/', { replace: true }) })}
          >
            You will lose access to <strong>{board.name}</strong> until the owner adds you again.
          </ConfirmDialog>
        </>
      )}
    </div>
  )
}

function LabelsTab({ board }: { board: BoardDetail }) {
  const createLabel = useCreateLabel(board.id)
  const [name, setName] = useState('')
  const [color, setColor] = useState('blue')

  const onSubmit = (event: FormEvent) => {
    event.preventDefault()
    createLabel.mutate({ name: name.trim(), color }, { onSuccess: () => setName('') })
  }

  return (
    <div className="space-y-6">
      <form onSubmit={onSubmit} className="space-y-3 rounded-xl bg-slate-50 p-4">
        <div className="flex gap-2">
          <label htmlFor="label-name" className="sr-only">
            Label name
          </label>
          <input
            id="label-name"
            className="input"
            placeholder="New label name"
            required
            maxLength={60}
            value={name}
            onChange={(event) => setName(event.target.value)}
          />
          <button type="submit" className="btn-primary shrink-0" disabled={!name.trim() || createLabel.isPending}>
            <Plus className="size-4" />
            Create
          </button>
        </div>
        <ColorPicker value={color} onChange={setColor} />
      </form>

      {board.labels.length === 0 ? (
        <p className="text-center text-sm text-slate-500">No labels yet. Labels help you group and filter cards.</p>
      ) : (
        <ul className="space-y-2">
          {board.labels.map((label) => (
            <LabelRow key={label.id} boardId={board.id} label={label} />
          ))}
        </ul>
      )}
    </div>
  )
}

function LabelRow({ boardId, label }: { boardId: number; label: Label }) {
  const [editing, setEditing] = useState(false)
  const [name, setName] = useState(label.name)
  const [color, setColor] = useState(label.color)
  const updateLabel = useUpdateLabel(boardId)
  const deleteLabel = useDeleteLabel(boardId)

  if (editing) {
    return (
      <li className="space-y-3 rounded-xl border border-slate-200 p-3">
        <div className="flex gap-2">
          <input
            className="input"
            aria-label="Label name"
            maxLength={60}
            value={name}
            onChange={(event) => setName(event.target.value)}
          />
          <button
            type="button"
            className="btn-primary shrink-0"
            disabled={!name.trim()}
            onClick={() => updateLabel.mutate({ id: label.id, name: name.trim(), color }, { onSuccess: () => setEditing(false) })}
          >
            <Check className="size-4" />
            Save
          </button>
        </div>
        <ColorPicker value={color} onChange={setColor} />
      </li>
    )
  }

  return (
    <li className="flex items-center gap-3">
      <span
        className="flex-1 truncate rounded-md px-3 py-1.5 text-sm font-semibold"
        style={{ backgroundColor: labelColor(label.color).bg, color: labelColor(label.color).fg }}
      >
        {label.name}
      </span>
      <button type="button" className="btn-ghost p-1.5" aria-label={`Edit ${label.name}`} onClick={() => setEditing(true)}>
        <Pencil className="size-4" />
      </button>
      <button
        type="button"
        className="btn-ghost p-1.5 hover:text-red-600"
        aria-label={`Delete ${label.name}`}
        onClick={() => deleteLabel.mutate(label.id)}
      >
        <Trash2 className="size-4" />
      </button>
    </li>
  )
}

function ColorPicker({ value, onChange }: { value: string; onChange: (color: string) => void }) {
  return (
    <div className="flex flex-wrap gap-2" role="radiogroup" aria-label="Label colour">
      {Object.entries(LABEL_COLORS).map(([key, { bg }]) => (
        <button
          key={key}
          type="button"
          role="radio"
          aria-checked={value === key}
          aria-label={key}
          onClick={() => onChange(key)}
          className={cn('size-7 rounded-md transition', value === key && 'ring-2 ring-slate-900 ring-offset-2')}
          style={{ backgroundColor: bg }}
        />
      ))}
    </div>
  )
}
