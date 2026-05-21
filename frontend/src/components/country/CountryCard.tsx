import type { Country } from '../../types/country'
import { CountryDetail } from './CountryDetail'

type Props = {
  country: Country
}

export function CountryCard({ country }: Props) {
  return (
    <article className="card-surface overflow-hidden transition-shadow duration-200 hover:shadow-md">
      <div className="relative aspect-[16/9] overflow-hidden bg-media">
        <img
          src={country.flag_url}
          alt={`Bandeira de ${country.name}`}
          className="h-full w-full object-cover"
        />
      </div>
      <div className="space-y-3 p-4">
        <div>
          <h2 className="font-display text-base font-semibold text-ink">
            {country.name}
          </h2>
          <p className="mt-0.5 line-clamp-2 text-xs text-muted">{country.official_name}</p>
        </div>
        <div className="space-y-2 border-t border-border pt-3">
          <CountryDetail label="Capital" value={country.capital ?? '—'} />
          <CountryDetail label="Região" value={country.region} />
          <CountryDetail
            label="População"
            value={country.population.toLocaleString('pt-BR')}
          />
          <CountryDetail label="Idioma" value={country.language ?? '—'} />
          {country.currency && (
            <CountryDetail label="Moeda" value={country.currency} />
          )}
        </div>
      </div>
    </article>
  )
}
