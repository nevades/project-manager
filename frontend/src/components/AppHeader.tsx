import { LayoutDashboard, LogOut, ShieldCheck } from 'lucide-react'
import { useEffect, useRef, useState } from 'react'
import { Link, NavLink, useNavigate } from 'react-router'
import { Avatar } from '@/components/Avatar'
import { Logo } from '@/components/Logo'
import { useLogout, useMe } from '@/lib/queries'
import { cn } from '@/lib/utils'

/** Top navigation. The translucent variant sits on top of a board's gradient background. */
export function AppHeader({ translucent = false }: { translucent?: boolean }) {
  const { data: me } = useMe()
  const logout = useLogout()
  const navigate = useNavigate()
  const [menuOpen, setMenuOpen] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (!menuOpen) return
    const onClick = (event: MouseEvent) => {
      if (!menuRef.current?.contains(event.target as Node)) setMenuOpen(false)
    }
    document.addEventListener('mousedown', onClick)
    return () => document.removeEventListener('mousedown', onClick)
  }, [menuOpen])

  const navLink = ({ isActive }: { isActive: boolean }) =>
    cn(
      'inline-flex items-center gap-2 rounded-lg px-3 py-1.5 text-sm font-medium transition',
      translucent
        ? 'text-white/90 hover:bg-white/15 hover:text-white'
        : isActive
          ? 'bg-brand-50 text-brand-700'
          : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900',
    )

  return (
    <header
      className={cn(
        'sticky top-0 z-30 flex h-14 shrink-0 items-center gap-4 px-4 sm:px-6',
        translucent ? 'bg-slate-950/25 backdrop-blur-md' : 'border-b border-slate-200 bg-white/80 backdrop-blur-md',
      )}
    >
      <Link to="/" aria-label="Tasklane home">
        <Logo inverted={translucent} />
      </Link>

      <nav className="flex items-center gap-1">
        <NavLink to="/" end className={navLink}>
          <LayoutDashboard className="size-4" />
          <span className="hidden sm:inline">Boards</span>
        </NavLink>
        {me?.role === 'ADMIN' && (
          <NavLink to="/admin" className={navLink}>
            <ShieldCheck className="size-4" />
            <span className="hidden sm:inline">Admin</span>
          </NavLink>
        )}
      </nav>

      <div className="ml-auto" ref={menuRef}>
        {me && (
          <div className="relative">
            <button
              type="button"
              onClick={() => setMenuOpen((open) => !open)}
              className="flex items-center rounded-full"
              aria-haspopup="menu"
              aria-expanded={menuOpen}
              aria-label="Account menu"
            >
              <Avatar user={me} />
            </button>
            {menuOpen && (
              <div
                role="menu"
                className="absolute right-0 mt-2 w-64 overflow-hidden rounded-xl bg-white shadow-xl ring-1 ring-slate-900/10"
              >
                <div className="border-b border-slate-100 px-4 py-3">
                  <p className="truncate text-sm font-semibold text-slate-900">{me.displayName}</p>
                  <p className="truncate text-xs text-slate-500">{me.email}</p>
                </div>
                <button
                  type="button"
                  role="menuitem"
                  onClick={() =>
                    logout.mutate(undefined, { onSettled: () => navigate('/login', { replace: true }) })
                  }
                  className="flex w-full items-center gap-2 px-4 py-2.5 text-left text-sm text-slate-700 hover:bg-slate-50"
                >
                  <LogOut className="size-4" />
                  Sign out
                </button>
              </div>
            )}
          </div>
        )}
      </div>
    </header>
  )
}
