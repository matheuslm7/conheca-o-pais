import axios from 'axios'
import { clearToken, getToken } from '../lib/auth/token'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
})

const PUBLIC_PATHS = ['/login', '/register']

api.interceptors.request.use((config) => {
  const token = getToken()
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      clearToken()

      const isPublicPage = PUBLIC_PATHS.some((path) =>
        window.location.pathname.startsWith(path)
      )

      if (!isPublicPage) {
        window.location.assign('/login')
      }
    }

    return Promise.reject(error)
  }
)

export default api
