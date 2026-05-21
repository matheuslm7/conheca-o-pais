import { Navigate, Outlet } from 'react-router-dom'
import { getToken } from '../lib/auth/token'

export function PrivateRoute() {
  const token = getToken()
  return token ? <Outlet /> : <Navigate to="/login" replace />
}
