import { useEffect, useState } from 'react'
import type { Country } from '../types/country'
import type { CountryListItem } from '../types/countryListItem'
import { getCountryApiErrorMessage } from '../lib/apiErrors'
import { getCountryByCode, listCountries } from '../services/countries.service'

export function useCountries() {
  const [countryList, setCountryList] = useState<CountryListItem[]>([])
  const [selectedCode, setSelectedCode] = useState('')
  const [country, setCountry] = useState<Country | null>(null)
  const [listLoading, setListLoading] = useState(true)
  const [detailLoading, setDetailLoading] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    let cancelled = false

    async function loadList() {
      setListLoading(true)
      setError('')

      try {
        const results = await listCountries()
        if (!cancelled) setCountryList(results)
      } catch (err) {
        if (!cancelled) {
          const message = getCountryApiErrorMessage(err)
          if (message) setError(message)
        }
      } finally {
        if (!cancelled) setListLoading(false)
      }
    }

    loadList()

    return () => {
      cancelled = true
    }
  }, [])

  async function selectCountry(code: string) {
    setSelectedCode(code)
    setCountry(null)

    if (!code) return

    setDetailLoading(true)
    setError('')

    try {
      const results = await getCountryByCode(code)
      setCountry(results[0] ?? null)
    } catch (err) {
      const message = getCountryApiErrorMessage(err)
      if (message) setError(message)
    } finally {
      setDetailLoading(false)
    }
  }

  return {
    countryList,
    selectedCode,
    country,
    listLoading,
    detailLoading,
    error,
    selectCountry,
  }
}
