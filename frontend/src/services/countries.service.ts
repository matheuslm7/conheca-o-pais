import api from '../api/axios'
import type { Country } from '../types/country'
import type { CountryListItem } from '../types/countryListItem'

export async function listCountries(): Promise<CountryListItem[]> {
  const { data } = await api.get<CountryListItem[]>('/api/v1/countries')
  return data
}

export async function getCountryByCode(code: string): Promise<Country[]> {
  const { data } = await api.get<Country[]>('/api/v1/countries', {
    params: { code: code.trim() },
  })
  return data
}
