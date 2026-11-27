import { useMutation, useQuery, useQueryClient, type QueryClient } from '@tanstack/react-query'
import { api, ApiError } from './api'
import type {
  AuthConfig,
  BoardDetail,
  BoardListData,
  BoardSummary,
  CardDetail,
  CardSummary,
  ChecklistItem,
  Comment,
  Label,
  Member,
  Role,
  UpdateCardInput,
  User,
} from './types'

export const keys = {
  me: ['me'] as const,
  authConfig: ['auth-config'] as const,
  boards: ['boards'] as const,
  board: (id: number) => ['board', id] as const,
  card: (id: number) => ['card', id] as const,
  adminUsers: ['admin-users'] as const,
}

// ---- Auth ------------------------------------------------------------------------------------------------

export function useMe() {
  return useQuery({
    queryKey: keys.me,
    queryFn: async () => {
      try {
        return await api.get<User>('/api/auth/me')
      } catch (error) {
        if (error instanceof ApiError && error.status === 401) return null
        throw error
      }
    },
    staleTime: 5 * 60_000,
    retry: false,
  })
}

export function useAuthConfig() {
  return useQuery({
    queryKey: keys.authConfig,
    queryFn: () => api.get<AuthConfig>('/api/auth/config'),
    staleTime: Infinity,
  })
}

export function useLogin() {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (input: { email: string; password: string }) => api.post<User>('/api/auth/login', input),
    onSuccess: (user) => client.setQueryData(keys.me, user),
    meta: { silent: true },
  })
}

export function useRegister() {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (input: { email: string; displayName: string; password: string }) =>
      api.post<User>('/api/auth/register', input),
    onSuccess: (user) => client.setQueryData(keys.me, user),
    meta: { silent: true },
  })
}

export function useLogout() {
  const client = useQueryClient()
  return useMutation({
    mutationFn: () => api.post<void>('/api/auth/logout'),
    onSettled: () => {
      client.clear()
      client.setQueryData(keys.me, null)
    },
  })
}

// ---- Boards ----------------------------------------------------------------------------------------------

export function useBoards() {
  return useQuery({ queryKey: keys.boards, queryFn: () => api.get<BoardSummary[]>('/api/boards') })
}

export function useBoard(boardId: number) {
  return useQuery({
    queryKey: keys.board(boardId),
    queryFn: () => api.get<BoardDetail>(`/api/boards/${boardId}`),
    enabled: Number.isFinite(boardId),
  })
}

export function useCreateBoard() {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (input: { name: string; description?: string; background: string }) =>
      api.post<BoardSummary>('/api/boards', input),
    onSuccess: () => client.invalidateQueries({ queryKey: keys.boards }),
  })
}

export function useUpdateBoard(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (input: { name: string; description: string | null; background: string }) =>
      api.put<BoardSummary>(`/api/boards/${boardId}`, input),
    onSuccess: () => invalidateBoard(client, boardId, true),
  })
}

export function useToggleStar() {
  const client = useQueryClient()
  return useMutation({
    mutationFn: ({ boardId, starred }: { boardId: number; starred: boolean }) =>
      api.put<void>(`/api/boards/${boardId}/star`, { starred }),
    onMutate: ({ boardId, starred }) => {
      client.setQueryData<BoardSummary[]>(keys.boards, (boards) =>
        boards?.map((board) => (board.id === boardId ? { ...board, starred } : board)),
      )
      client.setQueryData<BoardDetail>(keys.board(boardId), (board) => (board ? { ...board, starred } : board))
    },
    onSettled: (_data, _error, { boardId }) => invalidateBoard(client, boardId, true),
  })
}

export function useDeleteBoard() {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (boardId: number) => api.delete(`/api/boards/${boardId}`),
    onSuccess: (_data, boardId) => {
      client.removeQueries({ queryKey: keys.board(boardId) })
      return client.invalidateQueries({ queryKey: keys.boards })
    },
  })
}

export function useAddMember(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (email: string) => api.post<Member>(`/api/boards/${boardId}/members`, { email }),
    onSuccess: () => invalidateBoard(client, boardId),
  })
}

export function useRemoveMember(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (userId: number) => api.delete(`/api/boards/${boardId}/members/${userId}`),
    onSuccess: () => invalidateBoard(client, boardId, true),
  })
}

// ---- Labels ----------------------------------------------------------------------------------------------

export function useCreateLabel(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (input: { name: string; color: string }) => api.post<Label>(`/api/boards/${boardId}/labels`, input),
    onSuccess: () => invalidateBoard(client, boardId),
  })
}

export function useUpdateLabel(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: ({ id, ...input }: Label) => api.put<Label>(`/api/labels/${id}`, input),
    onSuccess: () => invalidateBoard(client, boardId),
  })
}

export function useDeleteLabel(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (labelId: number) => api.delete(`/api/labels/${labelId}`),
    onSuccess: () => {
      client.invalidateQueries({ queryKey: ['card'] })
      return invalidateBoard(client, boardId)
    },
  })
}

// ---- Lists -----------------------------------------------------------------------------------------------

export function useCreateList(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (name: string) => api.post<BoardListData>(`/api/boards/${boardId}/lists`, { name }),
    onSuccess: () => invalidateBoard(client, boardId),
  })
}

export function useRenameList(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: ({ listId, name }: { listId: number; name: string }) =>
      api.put<BoardListData>(`/api/lists/${listId}`, { name }),
    onMutate: ({ listId, name }) =>
      updateBoardCache(client, boardId, (board) => ({
        ...board,
        lists: board.lists.map((list) => (list.id === listId ? { ...list, name } : list)),
      })),
    onSettled: () => invalidateBoard(client, boardId),
  })
}

export function useDeleteList(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (listId: number) => api.delete(`/api/lists/${listId}`),
    onSuccess: () => invalidateBoard(client, boardId),
  })
}

export function useMoveList(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: ({ listId, position }: { listId: number; position: number }) =>
      api.post<void>(`/api/lists/${listId}/move`, { position }),
    onSettled: () => invalidateBoard(client, boardId),
  })
}

// ---- Cards -----------------------------------------------------------------------------------------------

export function useCreateCard(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: ({ listId, title }: { listId: number; title: string }) =>
      api.post<CardSummary>(`/api/lists/${listId}/cards`, { title }),
    onSuccess: (card) =>
      updateBoardCache(client, boardId, (board) => ({
        ...board,
        lists: board.lists.map((list) => (list.id === card.listId ? { ...list, cards: [...list.cards, card] } : list)),
      })),
    onSettled: () => invalidateBoard(client, boardId),
  })
}

export function useMoveCard(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: ({ cardId, listId, position }: { cardId: number; listId: number; position: number }) =>
      api.post<void>(`/api/cards/${cardId}/move`, { listId, position }),
    onSettled: (_data, _error, { cardId }) => {
      client.invalidateQueries({ queryKey: keys.card(cardId) })
      return invalidateBoard(client, boardId)
    },
  })
}

export function useCard(cardId: number | null) {
  return useQuery({
    queryKey: keys.card(cardId ?? -1),
    queryFn: () => api.get<CardDetail>(`/api/cards/${cardId}`),
    enabled: cardId !== null,
  })
}

export function useUpdateCard(boardId: number, cardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (input: UpdateCardInput) => api.put<CardDetail>(`/api/cards/${cardId}`, input),
    onSuccess: (card) => {
      client.setQueryData(keys.card(cardId), card)
      return invalidateBoard(client, boardId)
    },
  })
}

export function useDeleteCard(boardId: number) {
  const client = useQueryClient()
  return useMutation({
    mutationFn: (cardId: number) => api.delete(`/api/cards/${cardId}`),
    onSuccess: (_data, cardId) => {
      client.removeQueries({ queryKey: keys.card(cardId) })
      return invalidateBoard(client, boardId)
    },
  })
}

// ---- Checklist & comments --------------------------------------------------------------------------------

function useCardChildMutation<TVariables, TResult>(
  boardId: number,
  cardId: number,
  mutationFn: (variables: TVariables) => Promise<TResult>,
) {
  const client = useQueryClient()
  return useMutation({
    mutationFn,
    onSuccess: () => {
      client.invalidateQueries({ queryKey: keys.card(cardId) })
      return invalidateBoard(client, boardId)
    },
  })
}

export function useAddChecklistItem(boardId: number, cardId: number) {
  return useCardChildMutation(boardId, cardId, (content: string) =>
    api.post<ChecklistItem>(`/api/cards/${cardId}/checklist`, { content }),
  )
}

export function useUpdateChecklistItem(boardId: number, cardId: number) {
  return useCardChildMutation(boardId, cardId, ({ id, content, done }: ChecklistItem) =>
    api.put<ChecklistItem>(`/api/checklist-items/${id}`, { content, done }),
  )
}

export function useDeleteChecklistItem(boardId: number, cardId: number) {
  return useCardChildMutation(boardId, cardId, (itemId: number) => api.delete(`/api/checklist-items/${itemId}`))
}

export function useAddComment(boardId: number, cardId: number) {
  return useCardChildMutation(boardId, cardId, (body: string) =>
    api.post<Comment>(`/api/cards/${cardId}/comments`, { body }),
  )
}

export function useDeleteComment(boardId: number, cardId: number) {
  return useCardChildMutation(boardId, cardId, (commentId: number) => api.delete(`/api/comments/${commentId}`))
}

// ---- Admin -----------------------------------------------------------------------------------------------

export function useAdminUsers() {
  return useQuery({ queryKey: keys.adminUsers, queryFn: () => api.get<User[]>('/api/admin/users') })
}

export function useAdminUpdateUser() {
  const client = useQueryClient()
  return useMutation({
    mutationFn: ({ id, role, active }: { id: number; role: Role; active: boolean }) =>
      api.put<User>(`/api/admin/users/${id}`, { role, active }),
    onSuccess: (user) =>
      client.setQueryData<User[]>(keys.adminUsers, (users) => users?.map((u) => (u.id === user.id ? user : u))),
  })
}

// ---- Helpers ---------------------------------------------------------------------------------------------

export function updateBoardCache(client: QueryClient, boardId: number, update: (board: BoardDetail) => BoardDetail) {
  client.setQueryData<BoardDetail>(keys.board(boardId), (board) => (board ? update(board) : board))
}

function invalidateBoard(client: QueryClient, boardId: number, includeBoardList = false) {
  if (includeBoardList) client.invalidateQueries({ queryKey: keys.boards })
  return client.invalidateQueries({ queryKey: keys.board(boardId) })
}
