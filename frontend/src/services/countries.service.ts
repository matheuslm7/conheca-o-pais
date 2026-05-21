import api from '../api/axios'
import type { Country } from '../types/country'

export async function searchCountries(name: string): Promise<Country[]> {
  const { data } = await api.get<Country[]>('/api/v1/countries', {
    params: { name: name.trim() },
  })
  return data
}
