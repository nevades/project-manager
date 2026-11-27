import type { BoardDetail, BoardListData, CardSummary } from './types'

/**
 * Pure helpers for the drag-and-drop board. Sortable ids are prefixed strings so lists and cards never collide.
 */

export const listKey = (id: number) => `list-${id}`
export const cardKey = (id: number) => `card-${id}`
export const isListKey = (key: string | number) => String(key).startsWith('list-')
export const isCardKey = (key: string | number) => String(key).startsWith('card-')
export const idFromKey = (key: string | number) => Number(String(key).split('-')[1])

export function findListIndexOfCard(lists: BoardListData[], key: string | number): number {
  const id = idFromKey(key)
  return lists.findIndex((list) => list.cards.some((card) => card.id === id))
}

/** Index of the list a drop target refers to: either the list itself or the list containing a card. */
export function findTargetListIndex(lists: BoardListData[], overKey: string | number): number {
  if (isListKey(overKey)) {
    const id = idFromKey(overKey)
    return lists.findIndex((list) => list.id === id)
  }
  return findListIndexOfCard(lists, overKey)
}

/** Generic immutable array move. */
export function arrayMove<T>(items: T[], from: number, to: number): T[] {
  const copy = [...items]
  const [item] = copy.splice(from, 1)
  copy.splice(to, 0, item)
  return copy
}

/** Recomputes card positions and list ids from their order, as the server will. */
export function normalize(lists: BoardListData[]): BoardListData[] {
  return lists.map((list, listIndex) => ({
    ...list,
    position: listIndex,
    cards: list.cards.map((card, cardIndex) => ({ ...card, listId: list.id, position: cardIndex })),
  }))
}

/**
 * Moves a card to another list (used while dragging over a different column).
 * Returns the original array if nothing changes.
 */
export function moveCardToList(
  lists: BoardListData[],
  cardId: number,
  targetListIndex: number,
  targetIndex: number,
): BoardListData[] {
  const sourceListIndex = lists.findIndex((list) => list.cards.some((card) => card.id === cardId))
  if (sourceListIndex === -1 || targetListIndex < 0 || targetListIndex >= lists.length) return lists

  const next = lists.map((list) => ({ ...list, cards: [...list.cards] }))
  const source = next[sourceListIndex]
  const cardIndex = source.cards.findIndex((card) => card.id === cardId)
  const [card] = source.cards.splice(cardIndex, 1)

  const target = next[targetListIndex]
  const index = Math.max(0, Math.min(targetIndex, target.cards.length))
  target.cards.splice(index, 0, card as CardSummary)
  return next
}

/** Locates a card in the current state: which list it is in and at which index. */
export function locateCard(lists: BoardListData[], cardId: number): { listId: number; index: number } | null {
  for (const list of lists) {
    const index = list.cards.findIndex((card) => card.id === cardId)
    if (index !== -1) return { listId: list.id, index }
  }
  return null
}

/** Applies a text / assignee filter without changing the underlying order. */
export function filterCards(
  cards: CardSummary[],
  query: string,
  onlyUserId: number | null,
  labels: BoardDetail['labels'],
): CardSummary[] {
  const needle = query.trim().toLowerCase()
  return cards.filter((card) => {
    if (onlyUserId !== null && card.assignee?.id !== onlyUserId) return false
    if (!needle) return true
    if (card.title.toLowerCase().includes(needle)) return true
    return card.labelIds.some((id) => labels.find((label) => label.id === id)?.name.toLowerCase().includes(needle))
  })
}
