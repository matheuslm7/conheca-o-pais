import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react'
import {
  applyTheme,
  getStoredTheme,
  resolveDark,
  setStoredTheme,
  type Theme,
} from '../lib/theme'

type ThemeContextValue = {
  theme: Theme
  isDark: boolean
  setTheme: (theme: Theme) => void
  toggleTheme: () => void
}

const ThemeContext = createContext<ThemeContextValue | null>(null)

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setThemeState] = useState<Theme>(() => getStoredTheme())
  const [isDark, setIsDark] = useState(() => resolveDark(getStoredTheme()))

  const sync = useCallback((next: Theme) => {
    setThemeState(next)
    applyTheme(next)
    setIsDark(resolveDark(next))
  }, [])

  useEffect(() => {
    applyTheme(theme)
    setIsDark(resolveDark(theme))

    if (theme !== 'system') return

    const media = window.matchMedia('(prefers-color-scheme: dark)')
    const onChange = () => {
      applyTheme('system')
      setIsDark(media.matches)
    }

    media.addEventListener('change', onChange)
    return () => media.removeEventListener('change', onChange)
  }, [theme])

  const setTheme = useCallback((next: Theme) => {
    setStoredTheme(next)
    sync(next)
  }, [sync])

  const toggleTheme = useCallback(() => {
    const next: Theme = resolveDark(theme) ? 'light' : 'dark'
    setTheme(next)
  }, [theme, setTheme])

  const value = useMemo(
    () => ({ theme, isDark, setTheme, toggleTheme }),
    [theme, isDark, setTheme, toggleTheme],
  )

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>
}

export function useTheme() {
  const ctx = useContext(ThemeContext)
  if (!ctx) throw new Error('useTheme must be used within ThemeProvider')
  return ctx
}
