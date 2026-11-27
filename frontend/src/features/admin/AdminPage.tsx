import { ShieldCheck } from 'lucide-react'
import { Avatar } from '@/components/Avatar'
import { Spinner } from '@/components/Spinner'
import { useAdminUpdateUser, useAdminUsers, useMe } from '@/lib/queries'
import type { Role } from '@/lib/types'
import { cn, formatDateTime } from '@/lib/utils'

export function AdminPage() {
  const { data: me } = useMe()
  const { data: users, isPending, error } = useAdminUsers()
  const updateUser = useAdminUpdateUser()

  return (
    <div className="mx-auto max-w-5xl px-4 py-8 sm:px-6 lg:px-8">
      <div className="flex items-center gap-3">
        <span className="rounded-lg bg-brand-50 p-2 text-brand-700">
          <ShieldCheck className="size-5" />
        </span>
        <div>
          <h1 className="text-2xl font-semibold tracking-tight text-slate-900">User management</h1>
          <p className="text-sm text-slate-600">Change roles and deactivate accounts. Deactivated users cannot sign in.</p>
        </div>
      </div>

      {isPending && (
        <div className="flex justify-center py-20 text-slate-400">
          <Spinner className="size-8" />
        </div>
      )}
      {error && <p className="mt-8 text-sm text-red-600">Could not load users: {error.message}</p>}

      {users && (
        <div className="mt-8 overflow-x-auto rounded-xl bg-white shadow-sm ring-1 ring-slate-200">
          <table className="min-w-full divide-y divide-slate-200 text-sm">
            <thead className="bg-slate-50 text-left text-xs font-semibold tracking-wide text-slate-500 uppercase">
              <tr>
                <th scope="col" className="px-4 py-3">User</th>
                <th scope="col" className="px-4 py-3">Role</th>
                <th scope="col" className="px-4 py-3">Status</th>
                <th scope="col" className="hidden px-4 py-3 md:table-cell">Joined</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {users.map((user) => {
                const self = user.id === me?.id
                return (
                  <tr key={user.id} className={cn(!user.active && 'bg-slate-50/60')}>
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-3">
                        <Avatar user={user} className={cn(!user.active && 'opacity-50')} />
                        <div className="min-w-0">
                          <p className="truncate font-medium text-slate-900">
                            {user.displayName}
                            {self && <span className="ml-1 font-normal text-slate-500">(you)</span>}
                          </p>
                          <p className="truncate text-slate-500">{user.email}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-4 py-3">
                      <select
                        className="input w-32 py-1.5"
                        aria-label={`Role for ${user.displayName}`}
                        value={user.role}
                        disabled={self}
                        onChange={(event) =>
                          updateUser.mutate({ id: user.id, role: event.target.value as Role, active: user.active })
                        }
                      >
                        <option value="USER">Member</option>
                        <option value="ADMIN">Admin</option>
                      </select>
                    </td>
                    <td className="px-4 py-3">
                      <label className={cn('inline-flex items-center gap-2', self ? 'cursor-not-allowed' : 'cursor-pointer')}>
                        <input
                          type="checkbox"
                          role="switch"
                          className="peer sr-only"
                          checked={user.active}
                          disabled={self}
                          onChange={() => updateUser.mutate({ id: user.id, role: user.role, active: !user.active })}
                        />
                        <span className="relative h-5 w-9 rounded-full bg-slate-300 transition peer-checked:bg-emerald-500 peer-focus-visible:ring-2 peer-focus-visible:ring-brand-500 peer-disabled:opacity-50 after:absolute after:top-0.5 after:left-0.5 after:size-4 after:rounded-full after:bg-white after:shadow after:transition peer-checked:after:translate-x-4" />
                        <span className="text-slate-700">{user.active ? 'Active' : 'Deactivated'}</span>
                      </label>
                    </td>
                    <td className="hidden px-4 py-3 text-slate-500 md:table-cell">{formatDateTime(user.createdAt)}</td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
