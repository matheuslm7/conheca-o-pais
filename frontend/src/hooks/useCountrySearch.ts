import { useState } from 'react'
import type { Country } from '../types/country'
import { getCountrySearchErrorMessage } from '../lib/apiErrors'
import { searchCountries } from '../services/countries.service'

export function useCountrySearch() {
  const [query, setQuery] = useState('')
  const [countries, setCountries] = useState<Country[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [searched, setSearched] = useState(false)

  async function search() {
    if (!query.trim()) return

    setLoading(true)
    setError('')
    setSearched(true)

    try {
      const results = await searchCountries(query)
      setCountries(results)
    } catch (err) {
      const message = getCountrySearchErrorMessage(err)
      if (message) setError(message)
      setCountries([])
    } finally {
      setLoading(false)
    }
  }

  return {
    query,
    setQuery,
    countries,
    loading,
    error,
    searched,
    search,
  }
}
