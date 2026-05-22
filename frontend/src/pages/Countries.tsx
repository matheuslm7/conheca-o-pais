import { useNavigate } from 'react-router-dom'
import { CountryCard } from '../components/country/CountryCard'
import { AppHeader } from '../components/layout/AppHeader'
import { useCountries } from '../hooks/useCountries'
import { signOut } from '../services/auth.service'

export function Countries() {
  const navigate = useNavigate()
  const {
    countryList,
    selectedCode,
    country,
    listLoading,
    detailLoading,
    error,
    selectCountry,
  } = useCountries()

  async function handleLogout() {
    await signOut()
    navigate('/login')
  }

  return (
    <div className="min-h-dvh bg-surface">
      <AppHeader onLogout={handleLogout} />

      <main className="page-enter mx-auto max-w-5xl px-4 py-8 sm:px-6 sm:py-10">
        <section className="card-surface p-4 sm:p-5">
          <label htmlFor="country" className="mb-2 block text-xs font-medium text-muted">
            Escolha um país
          </label>
          <select
            id="country"
            className="input-field w-full"
            value={selectedCode}
            onChange={(e) => selectCountry(e.target.value)}
            disabled={listLoading}
          >
            <option value="">
              {listLoading ? 'Carregando países…' : 'Selecione um país'}
            </option>
            {countryList.map((item) => (
              <option key={item.code} value={item.code}>
                {item.name}
              </option>
            ))}
          </select>
        </section>

        <div className="mt-8">
          {listLoading && (
            <p className="text-center text-sm text-muted">Carregando lista de países…</p>
          )}

          {detailLoading && (
            <p className="text-center text-sm text-muted">Carregando informações…</p>
          )}

          {error && !listLoading && !detailLoading && (
            <p role="alert" className="alert-error text-center">
              {error}
            </p>
          )}

          {!listLoading && !detailLoading && !error && !selectedCode && (
            <p className="text-center text-sm text-muted">
              Selecione um país na lista para ver as informações.
            </p>
          )}

          {country && !detailLoading && (
            <div className="mx-auto max-w-sm">
              <CountryCard country={country} />
            </div>
          )}
        </div>
      </main>
    </div>
  )
}
