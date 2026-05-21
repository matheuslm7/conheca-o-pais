import type { ReactNode } from 'react'
import { Link } from 'react-router-dom'
import { ThemeToggle } from '../ThemeToggle'

type Props = {
  title: string
  subtitle: string
  children: ReactNode
  footer: ReactNode
}

export function AuthLayout({ title, subtitle, children, footer }: Props) {
  return (
    <div className="relative min-h-dvh flex items-center justify-center px-4 py-12 bg-surface">
      <div className="absolute right-4 top-4 sm:right-6 sm:top-6">
        <ThemeToggle />
      </div>
      <div className="page-enter w-full max-w-sm">
        <div className="mb-8 text-center">
          <Link
            to="/login"
            className="font-display text-2xl font-semibold tracking-tight text-ink"
          >
            Conheça o País
          </Link>
          <p className="mt-2 text-sm text-muted">{subtitle}</p>
        </div>

        <div className="card-surface p-8">
          <h1 className="font-display text-xl font-semibold text-ink">{title}</h1>
          <div className="mt-6">{children}</div>
        </div>

        <p className="mt-6 text-center text-sm text-muted">{footer}</p>
      </div>
    </div>
  )
}
