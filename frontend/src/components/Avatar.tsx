import { avatarColor, cn, initials } from '@/lib/utils'

interface AvatarProps {
  user: { id: number; displayName: string }
  size?: 'xs' | 'sm' | 'md'
  className?: string
}

const SIZES = {
  xs: 'size-6 text-[10px]',
  sm: 'size-8 text-xs',
  md: 'size-10 text-sm',
}

export function Avatar({ user, size = 'sm', className }: AvatarProps) {
  return (
    <span
      title={user.displayName}
      className={cn(
        'inline-flex shrink-0 items-center justify-center rounded-full font-semibold text-white ring-2 ring-white select-none',
        SIZES[size],
        className,
      )}
      style={{ backgroundColor: avatarColor(user.id) }}
    >
      {initials(user.displayName)}
    </span>
  )
}

export function AvatarStack({ users, max = 4 }: { users: { id: number; displayName: string }[]; max?: number }) {
  const visible = users.slice(0, max)
  const hidden = users.length - visible.length
  return (
    <div className="flex -space-x-2">
      {visible.map((user) => (
        <Avatar key={user.id} user={user} />
      ))}
      {hidden > 0 && (
        <span className="inline-flex size-8 items-center justify-center rounded-full bg-slate-200 text-xs font-semibold text-slate-700 ring-2 ring-white">
          +{hidden}
        </span>
      )}
    </div>
  )
}
