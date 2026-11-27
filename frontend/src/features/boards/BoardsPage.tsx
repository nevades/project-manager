import { LayoutGrid, Plus, Star } from 'lucide-react'
import { useState, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router'
import { Modal } from '@/components/Modal'
import { Spinner } from '@/components/Spinner'
import { useBoards, useCreateBoard, useMe, useToggleStar } from '@/lib/queries'
import { backgroundOf, DEFAULT_BACKGROUND } from '@/lib/theme'
import type { BoardSummary } from '@/lib/types'
import { BackgroundPicker } from './BackgroundPicker'

export function BoardsPage() {
  const { data: me } = useMe()
  const { data: boards, isPending, error } = useBoards()
  const [creating, setCreating] = useState(false)

  const starred = boards?.filter((board) => board.starred) ?? []

  return (
    <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="text-2xl font-semibold tracking-tight text-slate-900">
            {me ? `Hi, ${me.displayName.split(' ')[0]}` : 'Your boards'}
          </h1>
          <p className="mt-1 text-sm text-slate-600">Pick up a board or start something new.</p>
        </div>
        <button type="button" className="btn-primary" onClick={() => setCreating(true)}>
          <Plus className="size-4" />
          New board
        </button>
      </div>

      {isPending && (
        <div className="flex justify-center py-20 text-slate-400">
          <Spinner className="size-8" />
        </div>
      )}
      {error && <p className="mt-8 text-sm text-red-600">Could not load boards: {error.message}</p>}

      {boards && (
        <>
          {starred.length > 0 && (
            <section className="mt-10">
              <h2 className="section-title">
                <Star className="size-4" /> Starred
              </h2>
              <BoardGrid boards={starred} />
            </section>
          )}
          <section className="mt-10">
            <h2 className="section-title">
              <LayoutGrid className="size-4" /> All boards
            </h2>
            <BoardGrid boards={boards} onCreate={() => setCreating(true)} />
          </section>
        </>
      )}

      <CreateBoardDialog open={creating} onClose={() => setCreating(false)} />
    </div>
  )
}

function BoardGrid({ boards, onCreate }: { boards: BoardSummary[]; onCreate?: () => void }) {
  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
      {boards.map((board) => (
        <BoardTile key={board.id} board={board} />
      ))}
      {onCreate && (
        <button
          type="button"
          onClick={onCreate}
          className="flex h-32 flex-col items-center justify-center gap-2 rounded-xl border-2 border-dashed border-slate-300 text-sm font-medium text-slate-500 transition hover:border-brand-500 hover:bg-brand-50 hover:text-brand-700"
        >
          <Plus className="size-5" />
          Create new board
        </button>
      )}
    </div>
  )
}

function BoardTile({ board }: { board: BoardSummary }) {
  const toggleStar = useToggleStar()
  return (
    <Link
      to={`/boards/${board.id}`}
      className="group relative flex h-32 flex-col justify-between overflow-hidden rounded-xl p-4 shadow-sm transition hover:-translate-y-0.5 hover:shadow-lg"
      style={{ background: backgroundOf(board.background) }}
    >
      <div className="absolute inset-0 bg-slate-950/10 transition group-hover:bg-slate-950/0" />
      <div className="relative">
        <h3 className="line-clamp-2 font-semibold text-white drop-shadow-sm">{board.name}</h3>
        {board.description && <p className="mt-1 line-clamp-1 text-xs text-white/80">{board.description}</p>}
      </div>
      <div className="relative flex items-center justify-between">
        <span className="rounded-md bg-white/20 px-2 py-0.5 text-[11px] font-medium text-white backdrop-blur-sm">
          {board.role === 'OWNER' ? 'Owner' : 'Member'}
        </span>
        <button
          type="button"
          aria-label={board.starred ? 'Unstar board' : 'Star board'}
          onClick={(event) => {
            event.preventDefault()
            toggleStar.mutate({ boardId: board.id, starred: !board.starred })
          }}
          className={
            board.starred
              ? 'rounded-md p-1 text-amber-300'
              : 'rounded-md p-1 text-white/80 opacity-0 transition group-hover:opacity-100 hover:text-white focus:opacity-100'
          }
        >
          <Star className="size-4" fill={board.starred ? 'currentColor' : 'none'} />
        </button>
      </div>
    </Link>
  )
}

function CreateBoardDialog({ open, onClose }: { open: boolean; onClose: () => void }) {
  const [name, setName] = useState('')
  const [description, setDescription] = useState('')
  const [background, setBackground] = useState(DEFAULT_BACKGROUND)
  const createBoard = useCreateBoard()
  const navigate = useNavigate()

  const close = () => {
    setName('')
    setDescription('')
    setBackground(DEFAULT_BACKGROUND)
    onClose()
  }

  const onSubmit = (event: FormEvent) => {
    event.preventDefault()
    createBoard.mutate(
      { name, description: description || undefined, background },
      {
        onSuccess: (board) => {
          close()
          navigate(`/boards/${board.id}`)
        },
      },
    )
  }

  return (
    <Modal open={open} onClose={close} title="Create board">
      <form onSubmit={onSubmit} className="space-y-5 p-6">
        <div
          className="flex h-28 items-end rounded-xl p-4 shadow-inner"
          style={{ background: backgroundOf(background) }}
          aria-hidden="true"
        >
          <span className="font-semibold text-white drop-shadow">{name || 'Board preview'}</span>
        </div>
        <div>
          <span className="label">Background</span>
          <BackgroundPicker value={background} onChange={setBackground} />
        </div>
        <div>
          <label htmlFor="board-name" className="label">
            Board name
          </label>
          <input
            id="board-name"
            className="input"
            required
            maxLength={120}
            autoFocus
            value={name}
            onChange={(event) => setName(event.target.value)}
            placeholder="e.g. Product roadmap"
          />
        </div>
        <div>
          <label htmlFor="board-description" className="label">
            Description <span className="font-normal text-slate-400">(optional)</span>
          </label>
          <textarea
            id="board-description"
            className="input resize-none"
            rows={2}
            maxLength={2000}
            value={description}
            onChange={(event) => setDescription(event.target.value)}
          />
        </div>
        <p className="text-xs text-slate-500">New boards start with To do, In progress and Done lists.</p>
        <div className="flex justify-end gap-2">
          <button type="button" className="btn-secondary" onClick={close}>
            Cancel
          </button>
          <button type="submit" className="btn-primary" disabled={!name.trim() || createBoard.isPending}>
            {createBoard.isPending && <Spinner className="size-4" />}
            Create board
          </button>
        </div>
      </form>
    </Modal>
  )
}
