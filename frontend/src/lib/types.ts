// Mirrors the API response shapes from the Spring Boot backend.

export type Role = 'USER' | 'ADMIN'
export type MemberRole = 'OWNER' | 'MEMBER'
export type Priority = 'NONE' | 'LOW' | 'MEDIUM' | 'HIGH' | 'URGENT'

export interface User {
  id: number
  email: string
  displayName: string
  role: Role
  active: boolean
  createdAt: string
}

export interface UserSummary {
  id: number
  displayName: string
  email: string
}

export interface AuthConfig {
  registrationEnabled: boolean
  demoEnabled: boolean
}

export interface BoardSummary {
  id: number
  name: string
  description: string | null
  background: string
  starred: boolean
  role: MemberRole
  updatedAt: string
}

export interface Member extends UserSummary {
  role: MemberRole
}

export interface Label {
  id: number
  name: string
  color: string
}

export interface CardSummary {
  id: number
  listId: number
  title: string
  position: number
  priority: Priority
  dueDate: string | null
  completed: boolean
  assignee: UserSummary | null
  labelIds: number[]
  hasDescription: boolean
  checklistDone: number
  checklistTotal: number
  commentCount: number
}

export interface BoardListData {
  id: number
  name: string
  position: number
  cards: CardSummary[]
}

export interface BoardDetail {
  id: number
  name: string
  description: string | null
  background: string
  starred: boolean
  role: MemberRole
  members: Member[]
  labels: Label[]
  lists: BoardListData[]
}

export interface ChecklistItem {
  id: number
  content: string
  done: boolean
  position: number
}

export interface Comment {
  id: number
  body: string
  author: UserSummary
  createdAt: string
}

export interface CardDetail {
  id: number
  listId: number
  listName: string
  boardId: number
  title: string
  description: string | null
  priority: Priority
  dueDate: string | null
  completed: boolean
  assignee: UserSummary | null
  labelIds: number[]
  createdBy: UserSummary
  createdAt: string
  updatedAt: string
  checklist: ChecklistItem[]
  comments: Comment[]
}

export interface UpdateCardInput {
  title: string
  description: string | null
  priority: Priority
  dueDate: string | null
  assigneeId: number | null
  completed: boolean
  labelIds: number[]
}
