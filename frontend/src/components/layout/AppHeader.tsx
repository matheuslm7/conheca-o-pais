import { ThemeToggle } from '../ThemeToggle'

type Props = {
  onLogout: () => void
}

export function AppHeader({ onLogout }: Props) {
  return (
    <header className="sticky top-0 z-10 border-b border-border bg-card/90 backdrop-blur-sm">
      <div className="mx-auto flex max-w-5xl items-center justify-between px-4 py-4 sm:px-6">
        <div>
          <h1 className="font-display text-lg font-semibold tracking-tight text-ink">
            Conheça o País
          </h1>
          <p className="text-xs text-muted">Explore países pelo mundo</p>
        </div>
        <div className="flex items-center gap-1">
          <ThemeToggle />
          <button type="button" onClick={onLogout} className="btn-ghost">
            Sair
          </button>
        </div>
      </div>
    </header>
  )
}
