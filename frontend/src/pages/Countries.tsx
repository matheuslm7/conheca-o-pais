import { useNavigate } from 'react-router-dom'
import { CountryCard } from '../components/country/CountryCard'
import { AppHeader } from '../components/layout/AppHeader'
import { useCountrySearch } from '../hooks/useCountrySearch'
import { signOut } from '../services/auth.service'

export function Countries() {
  const navigate = useNavigate()
  const { query, setQuery, countries, loading, error, searched, search } =
    useCountrySearch()

  async function handleLogout() {
    await signOut()
    navigate('/login')
  }

  return (
    <div className="min-h-dvh bg-surface">
      <AppHeader onLogout={handleLogout} />

      <main className="page-enter mx-auto max-w-5xl px-4 py-8 sm:px-6 sm:py-10">
        <section className="card-surface p-4 sm:p-5">
          <label htmlFor="search" className="mb-2 block text-xs font-medium text-muted">
            Buscar país
          </label>
          <div className="flex flex-col gap-2 sm:flex-row">
            <input
              id="search"
              className="input-field sm:flex-1"
              placeholder="Ex.: Brasil, Japão, Portugal…"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && search()}
            />
            <button
              type="button"
              onClick={search}
              disabled={loading || !query.trim()}
              className="btn-primary shrink-0 px-6 sm:min-w-[7.5rem]"
            >
              {loading ? 'Buscando…' : 'Buscar'}
            </button>
          </div>
        </section>

        <div className="mt-8">
          {loading && (
            <p className="text-center text-sm text-muted">Buscando países…</p>
          )}

          {error && !loading && (
            <p role="alert" className="alert-error text-center">
              {error}
            </p>
          )}

          {!loading && !error && !searched && (
            <p className="text-center text-sm text-muted">
              Digite o nome de um país e clique em buscar.
            </p>
          )}

          {!loading && !error && searched && countries.length === 0 && (
            <p className="text-center text-sm text-muted">Nenhum resultado para essa busca.</p>
          )}

          {countries.length > 0 && (
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {countries.map((country) => (
                <CountryCard key={country.name} country={country} />
              ))}
            </div>
          )}
        </div>
      </main>
    </div>
  )
}
