import api from '../api/axios'
import { clearToken, extractTokenFromHeader, setToken } from '../lib/auth/token'

type Credentials = {
  email: string
  password: string
}

export class AuthError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'AuthError'
  }
}

export async function signIn({ email, password }: Credentials): Promise<void> {
  const response = await api.post('/users/sign_in', {
    user: { email, password },
  })

  const token = extractTokenFromHeader(response.headers.authorization)

  if (!token) {
    throw new AuthError('Não foi possível obter o token de autenticação.')
  }

  setToken(token)
}

export async function signUp({ email, password }: Credentials): Promise<void> {
  await api.post('/users', { user: { email, password } })
}

export async function signOut(): Promise<void> {
  try {
    await api.delete('/users/sign_out')
  } catch {
    // token expirado ou sessão já encerrada
  } finally {
    clearToken()
  }
}
