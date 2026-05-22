import axios from 'axios'

type ApiErrorBody = {
  error?: string
  errors?: string[]
}

export function getApiErrorMessage(error: unknown, fallback: string): string {
  if (axios.isAxiosError<ApiErrorBody>(error)) {
    const data = error.response?.data

    if (data?.errors?.length) return data.errors.join(' ')
    if (typeof data?.error === 'string') return data.error
  }

  return fallback
}

export function getCountryApiErrorMessage(error: unknown): string | null {
  if (!axios.isAxiosError<ApiErrorBody>(error)) {
    return 'Erro de conexão. Verifique sua internet e tente novamente.'
  }

  if (error.response?.status === 401) return null

  const serverError = error.response?.data?.error

  switch (error.response?.status) {
    case 404:
      return 'País não encontrado.'
    case 422:
      return typeof serverError === 'string'
        ? serverError
        : 'Selecione um país válido.'
    default:
      if (error.response && error.response.status >= 500) {
        return 'Serviço indisponível no momento. Tente novamente em instantes.'
      }
      if (!error.response) {
        return 'Erro de conexão. Verifique sua internet e tente novamente.'
      }
      return 'Não foi possível carregar os dados do país. Tente novamente.'
  }
}
