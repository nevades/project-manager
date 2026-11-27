import {
  closestCenter,
  DndContext,
  DragOverlay,
  getFirstCollision,
  KeyboardSensor,
  MeasuringStrategy,
  MouseSensor,
  pointerWithin,
  rectIntersection,
  TouchSensor,
  useSensor,
  useSensors,
  type CollisionDetection,
  type DragEndEvent,
  type DragOverEvent,
  type DragStartEvent,
  type UniqueIdentifier,
} from '@dnd-kit/core'
import { horizontalListSortingStrategy, SortableContext, sortableKeyboardCoordinates } from '@dnd-kit/sortable'
import { useQueryClient } from '@tanstack/react-query'
import { Search, Settings, Star, UserPlus, UserRound } from 'lucide-react'
import { useCallback, useEffect, useRef, useState } from 'react'
import { createPortal } from 'react-dom'
import { Link, useParams, useSearchParams } from 'react-router'
import { AppHeader } from '@/components/AppHeader'
import { AvatarStack } from '@/components/Avatar'
import { Spinner } from '@/components/Spinner'
import {
  arrayMove,
  cardKey,
  filterCards,
  findListIndexOfCard,
  findTargetListIndex,
  idFromKey,
  isCardKey,
  isListKey,
  listKey,
  locateCard,
  moveCardToList,
  normalize,
} from '@/lib/board-state'
import { useBoard, useMe, useMoveCard, useMoveList, useToggleStar, updateBoardCache } from '@/lib/queries'
import { backgroundOf } from '@/lib/theme'
import type { BoardDetail, BoardListData, CardSummary } from '@/lib/types'
import { cn } from '@/lib/utils'
import { CardModal } from '../card/CardModal'
import { BoardSettingsDialog, type SettingsTab } from './BoardSettingsDialog'
import { CardPreview } from './KanbanCard'
import { AddListForm, KanbanList } from './KanbanList'

export function BoardPage() {
  const boardId = Number(useParams().boardId)
  const { data: board, isPending, error } = useBoard(boardId)
  const [searchParams, setSearchParams] = useSearchParams()
  const [query, setQuery] = useState('')
  const [onlyMine, setOnlyMine] = useState(false)
  const [settingsTab, setSettingsTab] = useState<SettingsTab | null>(null)

  const openCardId = searchParams.get('card') ? Number(searchParams.get('card')) : null
  const openCard = useCallback(
    (cardId: number) => setSearchParams((params) => {
      params.set('card', String(cardId))
      return params
    }),
    [setSearchParams],
  )
  const closeCard = useCallback(
    () => setSearchParams((params) => {
      params.delete('card')
      return params
    }),
    [setSearchParams],
  )

  useEffect(() => {
    if (board) document.title = `${board.name} · Tasklane`
    return () => {
      document.title = 'Tasklane'
    }
  }, [board])

  if (isPending) {
    return (
      <div className="flex h-full flex-col bg-slate-800">
        <AppHeader translucent />
        <div className="flex flex-1 items-center justify-center text-white/70">
          <Spinner className="size-8" />
        </div>
      </div>
    )
  }

  if (error || !board) {
    return (
      <div className="flex h-full flex-col">
        <AppHeader />
        <div className="mx-auto max-w-md px-6 py-24 text-center">
          <h1 className="text-xl font-semibold text-slate-900">Board not available</h1>
          <p className="mt-2 text-slate-600">It may have been deleted, or you are not a member.</p>
          <Link to="/" className="btn-primary mt-6">
            Back to boards
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="flex h-full flex-col" style={{ background: backgroundOf(board.background) }}>
      <AppHeader translucent />
      <BoardHeader
        board={board}
        query={query}
        onQueryChange={setQuery}
        onlyMine={onlyMine}
        onOnlyMineChange={setOnlyMine}
        onOpenSettings={setSettingsTab}
      />
      <BoardCanvas board={board} query={query} onlyMine={onlyMine} onOpenCard={openCard} />
      {openCardId !== null && <CardModal board={board} cardId={openCardId} onClose={closeCard} />}
      <BoardSettingsDialog
        board={board}
        tab={settingsTab}
        onTabChange={setSettingsTab}
        onClose={() => setSettingsTab(null)}
      />
    </div>
  )
}

interface BoardHeaderProps {
  board: BoardDetail
  query: string
  onQueryChange: (value: string) => void
  onlyMine: boolean
  onOnlyMineChange: (value: boolean) => void
  onOpenSettings: (tab: SettingsTab) => void
}

function BoardHeader({ board, query, onQueryChange, onlyMine, onOnlyMineChange, onOpenSettings }: BoardHeaderProps) {
  const toggleStar = useToggleStar()
  const glass = 'rounded-lg bg-white/15 text-white backdrop-blur-sm transition hover:bg-white/25'

  return (
    <div className="flex flex-wrap items-center gap-2 px-4 py-3 sm:px-6">
      <h1 className="mr-1 max-w-full truncate text-lg font-semibold text-white drop-shadow-sm">{board.name}</h1>
      <button
        type="button"
        className={cn(glass, 'p-2', board.starred && 'text-amber-300')}
        aria-label={board.starred ? 'Unstar board' : 'Star board'}
        aria-pressed={board.starred}
        onClick={() => toggleStar.mutate({ boardId: board.id, starred: !board.starred })}
      >
        <Star className="size-4" fill={board.starred ? 'currentColor' : 'none'} />
      </button>

      <div className="ml-auto flex flex-wrap items-center gap-2">
        <label className="relative">
          <span className="sr-only">Filter cards</span>
          <Search className="pointer-events-none absolute top-1/2 left-2.5 size-4 -translate-y-1/2 text-white/70" />
          <input
            type="search"
            value={query}
            onChange={(event) => onQueryChange(event.target.value)}
            placeholder="Filter cards…"
            className="w-44 rounded-lg bg-white/15 py-1.5 pr-3 pl-8 text-sm text-white backdrop-blur-sm placeholder:text-white/70 focus:bg-white/25 focus:outline-none sm:w-56"
          />
        </label>
        <button
          type="button"
          aria-pressed={onlyMine}
          onClick={() => onOnlyMineChange(!onlyMine)}
          className={cn(glass, 'inline-flex items-center gap-1.5 px-3 py-1.5 text-sm font-medium', onlyMine && 'bg-white text-slate-900 hover:bg-white')}
        >
          <UserRound className="size-4" />
          My cards
        </button>
        <button type="button" onClick={() => onOpenSettings('members')} className="hidden sm:block" aria-label="Board members">
          <AvatarStack users={board.members} />
        </button>
        {board.role === 'OWNER' && (
          <button
            type="button"
            onClick={() => onOpenSettings('members')}
            className="inline-flex items-center gap-1.5 rounded-lg bg-white px-3 py-1.5 text-sm font-medium text-slate-900 shadow-sm hover:bg-slate-100"
          >
            <UserPlus className="size-4" />
            Share
          </button>
        )}
        <button type="button" className={cn(glass, 'p-2')} aria-label="Board settings" onClick={() => onOpenSettings('general')}>
          <Settings className="size-4" />
        </button>
      </div>
    </div>
  )
}

type ActiveItem = { type: 'card'; card: CardSummary } | { type: 'list'; list: BoardListData } | null

interface BoardCanvasProps {
  board: BoardDetail
  query: string
  onlyMine: boolean
  onOpenCard: (cardId: number) => void
}

/**
 * The drag-and-drop surface. Local state mirrors the server board so items can move freely while dragging;
 * the final position is sent to the API on drop and the cache is updated optimistically.
 */
function BoardCanvas({ board, query, onlyMine, onOpenCard }: BoardCanvasProps) {
  const client = useQueryClient()
  const { data: me } = useMe()
  const moveCard = useMoveCard(board.id)
  const moveList = useMoveList(board.id)

  const [lists, setLists] = useState<BoardListData[]>(board.lists)
  const [active, setActive] = useState<ActiveItem>(null)
  const dragging = useRef(false)
  const origin = useRef<{ listId: number; index: number } | null>(null)
  const lastOverId = useRef<UniqueIdentifier | null>(null)

  // Follow server updates, except mid-drag where local state is authoritative.
  useEffect(() => {
    if (!dragging.current) setLists(board.lists)
  }, [board.lists])

  const filtering = query.trim() !== '' || onlyMine
  const visibleCards = (list: BoardListData) =>
    filtering ? filterCards(list.cards, query, onlyMine ? (me?.id ?? -1) : null, board.labels) : list.cards

  const sensors = useSensors(
    useSensor(MouseSensor, { activationConstraint: { distance: 6 } }),
    useSensor(TouchSensor, { activationConstraint: { delay: 200, tolerance: 6 } }),
    useSensor(KeyboardSensor, {
      coordinateGetter: sortableKeyboardCoordinates,
      keyboardCodes: { start: ['Space'], cancel: ['Escape'], end: ['Space', 'Enter'] },
    }),
  )

  const collisionDetection: CollisionDetection = useCallback(
    (args) => {
      if (active?.type === 'list') {
        return closestCenter({
          ...args,
          droppableContainers: args.droppableContainers.filter((container) => isListKey(container.id)),
        })
      }
      const pointerHits = pointerWithin(args)
      const hits = pointerHits.length > 0 ? pointerHits : rectIntersection(args)
      let overId = getFirstCollision(hits, 'id')
      if (overId != null) {
        // Over a list: snap to the closest card inside it, if any.
        if (isListKey(overId)) {
          const list = lists.find((candidate) => listKey(candidate.id) === overId)
          if (list && list.cards.length > 0) {
            const cardKeys = new Set(list.cards.map((card) => cardKey(card.id)))
            const closest = closestCenter({
              ...args,
              droppableContainers: args.droppableContainers.filter((container) => cardKeys.has(String(container.id))),
            })
            if (closest.length > 0) overId = closest[0].id
          }
        }
        lastOverId.current = overId
        return [{ id: overId }]
      }
      return lastOverId.current != null ? [{ id: lastOverId.current }] : []
    },
    [active, lists],
  )

  const resetDrag = () => {
    setActive(null)
    dragging.current = false
    origin.current = null
    lastOverId.current = null
  }

  const commit = (next: BoardListData[]) => {
    const normalized = normalize(next)
    setLists(normalized)
    updateBoardCache(client, board.id, (current) => ({ ...current, lists: normalized }))
  }

  const handleDragStart = ({ active: dragged }: DragStartEvent) => {
    dragging.current = true
    if (isListKey(dragged.id)) {
      const list = lists.find((candidate) => listKey(candidate.id) === dragged.id)
      if (list) setActive({ type: 'list', list })
      return
    }
    const cardId = idFromKey(dragged.id)
    origin.current = locateCard(lists, cardId)
    const card = lists.flatMap((list) => list.cards).find((candidate) => candidate.id === cardId)
    if (card) setActive({ type: 'card', card })
  }

  const handleDragOver = ({ active: dragged, over }: DragOverEvent) => {
    if (!over || !isCardKey(dragged.id)) return
    const cardId = idFromKey(dragged.id)
    setLists((current) => {
      const fromIndex = findListIndexOfCard(current, dragged.id)
      const toIndex = findTargetListIndex(current, over.id)
      if (fromIndex === -1 || toIndex === -1 || fromIndex === toIndex) return current

      const targetCards = current[toIndex].cards
      let index = targetCards.length
      if (isCardKey(over.id)) {
        const overIndex = targetCards.findIndex((card) => cardKey(card.id) === over.id)
        const draggedRect = dragged.rect.current.translated
        const below = draggedRect != null && draggedRect.top > over.rect.top + over.rect.height / 2
        index = overIndex === -1 ? targetCards.length : overIndex + (below ? 1 : 0)
      }
      return moveCardToList(current, cardId, toIndex, index)
    })
  }

  const handleDragEnd = ({ active: dragged, over }: DragEndEvent) => {
    const start = origin.current
    resetDrag()
    if (!over) {
      setLists(board.lists)
      return
    }

    if (isListKey(dragged.id)) {
      const from = lists.findIndex((list) => listKey(list.id) === dragged.id)
      const to = findTargetListIndex(lists, over.id)
      if (from !== -1 && to !== -1 && from !== to) {
        commit(arrayMove(lists, from, to))
        moveList.mutate({ listId: idFromKey(dragged.id), position: to })
      }
      return
    }

    const cardId = idFromKey(dragged.id)
    let next = lists
    const listIndex = findListIndexOfCard(next, dragged.id)
    if (listIndex !== -1 && isCardKey(over.id) && findTargetListIndex(next, over.id) === listIndex) {
      const cards = next[listIndex].cards
      const from = cards.findIndex((card) => card.id === cardId)
      const to = cards.findIndex((card) => cardKey(card.id) === over.id)
      if (from !== -1 && to !== -1 && from !== to) {
        next = next.map((list, index) => (index === listIndex ? { ...list, cards: arrayMove(cards, from, to) } : list))
      }
    }

    commit(next)
    const end = locateCard(next, cardId)
    if (start && end && (start.listId !== end.listId || start.index !== end.index)) {
      moveCard.mutate({ cardId, listId: end.listId, position: end.index })
    }
  }

  const handleDragCancel = () => {
    resetDrag()
    setLists(board.lists)
  }

  return (
    <DndContext
      sensors={sensors}
      collisionDetection={collisionDetection}
      measuring={{ droppable: { strategy: MeasuringStrategy.Always } }}
      onDragStart={handleDragStart}
      onDragOver={handleDragOver}
      onDragEnd={handleDragEnd}
      onDragCancel={handleDragCancel}
    >
      <div className="scrollbar-thin flex min-h-0 flex-1 items-start gap-3 overflow-x-auto px-4 pb-4 sm:px-6">
        <SortableContext items={lists.map((list) => listKey(list.id))} strategy={horizontalListSortingStrategy}>
          {lists.map((list) => (
            <KanbanList
              key={list.id}
              boardId={board.id}
              list={list}
              cards={visibleCards(list)}
              labels={board.labels}
              dragDisabled={filtering}
              onOpenCard={onOpenCard}
            />
          ))}
        </SortableContext>
        <AddListForm boardId={board.id} />
      </div>
      {createPortal(
        <DragOverlay dropAnimation={{ duration: 180, easing: 'cubic-bezier(0.2, 0, 0, 1)' }}>
          {active?.type === 'card' && <CardPreview card={active.card} labels={board.labels} overlay />}
          {active?.type === 'list' && (
            <div className="w-72 rotate-2 rounded-xl bg-slate-100 p-3 shadow-2xl ring-2 ring-brand-500/40">
              <p className="text-sm font-semibold text-slate-800">{active.list.name}</p>
              <p className="mt-1 text-xs text-slate-500">{active.list.cards.length} cards</p>
            </div>
          )}
        </DragOverlay>,
        document.body,
      )}
    </DndContext>
  )
}
