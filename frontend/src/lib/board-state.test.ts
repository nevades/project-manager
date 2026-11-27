import { describe, expect, it } from 'vitest'
import {
  arrayMove,
  cardKey,
  filterCards,
  findTargetListIndex,
  idFromKey,
  listKey,
  locateCard,
  moveCardToList,
  normalize,
} from './board-state'
import type { BoardListData, CardSummary } from './types'

function card(id: number, listId: number, overrides: Partial<CardSummary> = {}): CardSummary {
  return {
    id,
    listId,
    title: `Card ${id}`,
    position: 0,
    priority: 'NONE',
    dueDate: null,
    completed: false,
    assignee: null,
    labelIds: [],
    hasDescription: false,
    checklistDone: 0,
    checklistTotal: 0,
    commentCount: 0,
    ...overrides,
  }
}

const lists: BoardListData[] = [
  { id: 1, name: 'To do', position: 0, cards: [card(10, 1), card(11, 1), card(12, 1)] },
  { id: 2, name: 'Doing', position: 1, cards: [card(20, 2)] },
  { id: 3, name: 'Done', position: 2, cards: [] },
]

describe('keys', () => {
  it('round-trips ids', () => {
    expect(idFromKey(listKey(7))).toBe(7)
    expect(idFromKey(cardKey(42))).toBe(42)
  })

  it('finds the target list for list and card keys', () => {
    expect(findTargetListIndex(lists, listKey(3))).toBe(2)
    expect(findTargetListIndex(lists, cardKey(20))).toBe(1)
    expect(findTargetListIndex(lists, cardKey(999))).toBe(-1)
  })
})

describe('moveCardToList', () => {
  it('moves a card into another list at the given index', () => {
    const next = moveCardToList(lists, 11, 1, 0)
    expect(next[0].cards.map((c) => c.id)).toEqual([10, 12])
    expect(next[1].cards.map((c) => c.id)).toEqual([11, 20])
  })

  it('appends when moving into an empty list', () => {
    const next = moveCardToList(lists, 10, 2, 5)
    expect(next[2].cards.map((c) => c.id)).toEqual([10])
  })

  it('does not mutate the input', () => {
    moveCardToList(lists, 10, 1, 0)
    expect(lists[0].cards).toHaveLength(3)
    expect(lists[1].cards).toHaveLength(1)
  })

  it('returns the same array for unknown cards', () => {
    expect(moveCardToList(lists, 999, 1, 0)).toBe(lists)
  })
})

describe('normalize and locate', () => {
  it('renumbers positions and list ids', () => {
    const moved = normalize(moveCardToList(lists, 12, 1, 1))
    expect(moved[1].cards.map((c) => [c.id, c.listId, c.position])).toEqual([
      [20, 2, 0],
      [12, 2, 1],
    ])
    expect(locateCard(moved, 12)).toEqual({ listId: 2, index: 1 })
  })

  it('moves array items', () => {
    expect(arrayMove(['a', 'b', 'c'], 0, 2)).toEqual(['b', 'c', 'a'])
  })
})

describe('filterCards', () => {
  const labels = [{ id: 1, name: 'Bug', color: 'red' }]
  const cards = [
    card(1, 1, { title: 'Fix login', assignee: { id: 5, displayName: 'A', email: 'a@x.io' } }),
    card(2, 1, { title: 'Write docs', labelIds: [1] }),
  ]

  it('matches titles and label names case-insensitively', () => {
    expect(filterCards(cards, 'LOGIN', null, labels).map((c) => c.id)).toEqual([1])
    expect(filterCards(cards, 'bug', null, labels).map((c) => c.id)).toEqual([2])
  })

  it('filters by assignee', () => {
    expect(filterCards(cards, '', 5, labels).map((c) => c.id)).toEqual([1])
  })
})
