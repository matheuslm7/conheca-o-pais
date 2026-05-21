# Conheça o País

Aplicação web para buscar informações de países (capital, população, bandeira, idioma, moeda, etc.). O usuário se cadastra, faz login e consulta países pelo nome — inclusive em português (ex.: *Brasil*, *Japão*).

| Frontend | Backend | Banco |
|----------|---------|-------|
| http://localhost:5173 | http://localhost:3000 | PostgreSQL 16 |

## O que este projeto demonstra

- **API REST** em Rails (JSON), com autenticação **JWT** (Devise)
- **Integração** com API externa ([REST Countries](https://restcountries.com)) e tratamento de erros (404, validação)
- **Frontend** em React + TypeScript, rotas protegidas e consumo da API via Axios
- **Testes** no backend (RSpec + WebMock)
- **Ambiente** containerizado com Docker Compose

## Stack

| Camada | Tecnologias |
|--------|-------------|
| Backend | Ruby 3.3, Rails 7.1, PostgreSQL, Devise + JWT |
| Frontend | React 18, TypeScript, Vite, Tailwind CSS |
| Infra | Docker, Docker Compose |

## Como rodar

**Pré-requisito:** [Docker](https://docs.docker.com/get-docker/)

```bash
git clone https://github.com/matheuslm7/conheca-o-pais
cd conheca-o-pais
cp .env.example .env
```

Gere as chaves no `.env` (valores de exemplo no `.env.example`):

```bash
openssl rand -hex 16   # RAILS_MASTER_KEY
openssl rand -hex 64   # JWT_SECRET_KEY
```

Suba tudo:

```bash
docker compose up --build
```

Na primeira vez pode demorar (gems, migrations). Depois acesse o frontend em **http://localhost:5173**.

## Testes

```bash
docker compose exec -e RAILS_ENV=test backend bundle exec rspec
```

> Os request specs precisam do ambiente `test`. No Docker o container vem com `RAILS_ENV=development`; use `-e RAILS_ENV=test` ou force `ENV["RAILS_ENV"] = "test"` no `spec/rails_helper.rb`.

## API (resumo)

Base: `http://localhost:3000`

| Método | Endpoint | Auth | Descrição |
|--------|----------|------|-----------|
| POST | `/users` | Não | Cadastro |
| POST | `/users/sign_in` | Não | Login — JWT no header `Authorization` |
| DELETE | `/users/sign_out` | Sim | Logout |
| GET | `/api/v1/countries?name=Brasil` | Sim | Busca país por nome |

**Exemplo de resposta** (`GET /api/v1/countries?name=Brasil`):

```json
[
  {
    "name": "Brazil",
    "official_name": "Federative Republic of Brazil",
    "capital": "Brasília",
    "region": "Americas",
    "population": 212400000,
    "flag_url": "https://flagcdn.com/br.svg",
    "language": "Portuguese",
    "currency": "Brazilian real (R$)"
  }
]
```

A busca tenta primeiro o endpoint `/name` e, se não achar, `/fullText` (útil para nomes em português).

## Estrutura

```
conheca-o-pais/
├── backend/     # API Rails
├── frontend/    # App React
└── docker-compose.yml
```

**Backend:** controllers (`api/v1`, `users`), service `Countries::Fetcher`, serializer, specs RSpec.  
**Frontend:** páginas Login/Cadastro/Busca, hooks, serviços HTTP, rotas privadas.

## Comandos úteis

```bash
docker compose logs -f backend
docker compose exec backend bundle exec rails db:migrate
docker compose down          # parar
docker compose down -v       # parar e resetar volumes
```

## Fluxo para testar manualmente

1. Cadastre-se e faça login no frontend
2. Busque um país (ex.: `Brasil`, `Portugal`)
3. Opcional: teste a API com Postman/Insomnia — login em `/users/sign_in`, copie o header `Authorization` e use em `GET /api/v1/countries?name=...`

---
