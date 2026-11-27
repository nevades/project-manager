import { createBrowserRouter, Navigate, Outlet, RouterProvider, useLocation } from 'react-router'
import { AppHeader } from '@/components/AppHeader'
import { FullPageSpinner } from '@/components/Spinner'
import { AdminPage } from '@/features/admin/AdminPage'
import { LoginPage, RegisterPage } from '@/features/auth/AuthPages'
import { BoardPage } from '@/features/board/BoardPage'
import { BoardsPage } from '@/features/boards/BoardsPage'
import { NotFoundPage } from '@/features/NotFoundPage'
import { useMe } from '@/lib/queries'

/** Routes that need a signed-in user. Redirects to /login and comes back afterwards. */
function RequireAuth() {
  const { data: me, isPending } = useMe()
  const location = useLocation()
  if (isPending) return <FullPageSpinner />
  if (!me) return <Navigate to="/login" replace state={{ from: location.pathname + location.search }} />
  return <Outlet />
}

function RequireAdmin() {
  const { data: me } = useMe()
  return me?.role === 'ADMIN' ? <Outlet /> : <Navigate to="/" replace />
}

/** Login and registration are only shown to signed-out visitors. */
function GuestOnly() {
  const { data: me, isPending } = useMe()
  if (isPending) return <FullPageSpinner />
  return me ? <Navigate to="/" replace /> : <Outlet />
}

function StandardLayout() {
  return (
    <div className="flex min-h-full flex-col">
      <AppHeader />
      <main className="flex-1">
        <Outlet />
      </main>
    </div>
  )
}

const router = createBrowserRouter([
  {
    element: <GuestOnly />,
    children: [
      { path: '/login', element: <LoginPage /> },
      { path: '/register', element: <RegisterPage /> },
    ],
  },
  {
    element: <RequireAuth />,
    children: [
      // The board page renders its own translucent header over the board background.
      { path: '/boards/:boardId', element: <BoardPage /> },
      {
        element: <StandardLayout />,
        children: [
          { path: '/', element: <BoardsPage /> },
          { element: <RequireAdmin />, children: [{ path: '/admin', element: <AdminPage /> }] },
          { path: '*', element: <NotFoundPage /> },
        ],
      },
    ],
  },
])

export function App() {
  return <RouterProvider router={router} />
}
