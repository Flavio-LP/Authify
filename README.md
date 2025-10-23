# 🔐 Authify

> **Autenticação JWT robusta com API Rails** — Segurança, boas práticas e documentação completa

[![Rails](https://img.shields.io/badge/Rails-8.0.2-red.svg)](https://rubyonrails.org/)

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16.8+-blue.svg)](https://www.postgresql.org/)

[![JWT](https://img.shields.io/badge/JWT-Auth-green.svg)](https://jwt.io/)

[![RSpec](https://img.shields.io/badge/Tests-RSpec-orange.svg)](https://rspec.info/)

API Rails moderna com autenticação JWT, controle de sessão via token, blacklist de tokens revogados e documentação Swagger interativa.

---

## 🎯 Objetivo

Demonstrar implementação profissional de autenticação JWT em Rails API com:

- ✅ **Cadastro e login** de usuários
- ✅ **Proteção de rotas** via JWT (Bearer token)
- ✅ **Revogação de tokens** por JTI (blacklist/denylist)
- ✅ **Boas práticas REST** e segurança
- ✅ **Documentação Swagger** com RSwag
- ✅ **Testes completos** com RSpec
- ✅ **Observabilidade** básica e healthcheck

---

## 🚀 Stack Tecnológica

| Tecnologia | Versão | Propósito |
|------------|--------|-----------|
| **Rails** | 8.0.2 | Framework API-only |
| **PostgreSQL** | 16.8+ | Banco de dados |
| **Devise** | ~> 4.9 | Autenticação de usuários |
| **Devise-JWT** | ~> 0.11 | Emissão/validação de JWT |
| **RSpec** | ~> 6.0 | Framework de testes |
| **RSwag** | ~> 2.10 | Documentação OpenAPI/Swagger |
| **Rack-CORS** | ~> 2.0 | Controle de CORS |
| **Rack-Attack** | ~> 6.6 | Rate limiting (opcional) |

---

## 📋 Pré-requisitos

- Ruby 3.2.8+
- Rails 8.0.2+
- PostgreSQL 16.8+
- Bundler 2.6.6

---

## ⚙️ Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/Flavio-LP/authify.git
cd authify
```

### 2. Instale as dependências

```bash
bundle install
```

### 3. Configure o banco de dados

```bash
# Edite config/database.yml com suas credenciais PostgreSQL
cp config/database.yml.example config/database.yml

# Crie e migre o banco
rails db:create db:migrate
```

### 4. Configure variáveis de ambiente

```bash
cp .env.example .env
# Edite .env com suas configurações
```

Variáveis importantes:
```env
PG_HOST = "your_host"
PG_PORT = "your_port"
PG_USER = "your_user"
PG_PASSWORD = "your_password"
PG_DATABASE = "your_database"
PG_SCHEMA = "your_schema"
DEVISE_JWT_SECRET_KEY = "your secret key"
```

### 5. Inicie o servidor

```bash
rails server
```

A API estará disponível em `http://localhost:3000`

---

## 🏗️ Arquitetura

### Fluxo de Autenticação

```
┌─────────────┐
│   Cliente   │
└──────┬──────┘
       │
       │ POST /users
       ├──────────────────────────────────┐
       │                                  │
       │ POST /users/ sign_in             ▼
       ├────────────────────────────► ┌──────────────┐
       │                              │  Rails API   │
       │ ◄────────────────────────────┤  + Devise    │
       │   JWT Token (Header)         │  + JWT       │
       │                              └──────┬───────┘
       │                                     │
       │ GET /profile                        │
       │ Authorization: Bearer <token>       │
       ├────────────────────────────────►    │
       │                                     │
       │ ◄────────────────────────────────   │
       │   User Data (JSON)                  │
       │                                     │
       │ DELETE /auth/logout                 │
       ├────────────────────────────────►    │
       │                              ┌──────▼───────┐
       │                              │ JWT Denylist │
       │                              │  (Blacklist) │
       └──────────────────────────────┴──────────────┘
```

### Componentes Principais

1. **Devise**: Gerencia User model, validações e autenticação base
2. **Devise-JWT**: 
   - Emite JWT no login (`Sessions#create`)
   - Valida token em rotas protegidas
   - Revoga tokens via JTI blacklist
3. **JwtDenylist**: Model para armazenar tokens revogados
4. **RSwag**: Gera documentação OpenAPI a partir dos testes

---

## 📊 Modelagem de Dados

### Tabela `users`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | bigint | Primary key |
| `email` | string | Email único (index) |
| `encrypted_password` | string | Senha criptografada (Devise) |
| `created_at` | datetime | Data de criação |
| `updated_at` | datetime | Data de atualização |
| `jti` | string | JWT ID único (index) |
| `name` | string | Nome do usuário (opcional) |

### Tabela `jwt_denylist`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | bigint | Primary key |
| `jti` | string | JWT ID revogado (unique, index) |
| `exp` | datetime | Data de expiração do token |
| `created_at` | datetime | Data de revogação |

---

## 🔌 Endpoints da API

### 🌐 Públicos

#### `POST /users`
Cria novo usuário.

**Request:**
```json
{
  "user": {
    "email": "user@example.com",
    "password": "senha123",
    "password_confirmation": "senha123",
    "name": "João Silva"
  }
}
```

**Response:** `201 Created`
```json
{
  "message": "Usuário criado com sucesso",
  "token" : "your token",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "João Silva"
  }
}
```

---

#### `POST /users/sign_in`
Autentica usuário e retorna JWT.

**Request:**
```json
{
  "user": {
    "email": "user@example.com",
    "password": "senha123"
  }
}
```

**Response:** `200 OK`
```
Headers:
  Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...

Body:
{
  "message": "Login realizado com sucesso",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "João Silva"
  }
}
```

---

#### `GET /health`
Healthcheck da aplicação.

**Response:** `200 OK`
```json
{
  "status": "ok",
  "timestamp": "2025-10-19T10:30:00Z",
  "database": "connected"
}
```

---

### 🔒 Protegidos (requerem `Authorization: Bearer <token>`)

#### `GET /profile`
Retorna dados do usuário autenticado.

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "email": "user@example.com",
  "name": "João Silva",
  "created_at": "2025-10-19T10:00:00Z"
}
```

---

#### `DELETE /auth/logout`
Revoga o token atual (adiciona à blacklist).

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

**Response:** `200 OK`
```json
{
  "message": "Logout realizado com sucesso"
}
```

---

#### `GET /accounts/:id`
Exemplo de rota protegida.

**Response:** `200 OK`
```json
{
  "id": 1,
  "account_data": "..."
}
```

---

## 🔐 Segurança

### Configurações Implementadas

- ✅ **JWT com expiração curta** (15 minutos padrão)
- ✅ **Blacklist de tokens** via JTI
- ✅ **CORS configurado** para origens permitidas
- ✅ **Rate limiting** com Rack-Attack (opcional)
- ✅ **Senhas criptografadas** com bcrypt (Devise)
- ✅ **Validações de email** único e formato
- ✅ **HTTPS recomendado** em produção

### Boas Práticas

```ruby
# Configuração JWT (config/initializers/devise.rb)
config.jwt do |jwt|
  jwt.secret = ENV['DEVISE_JWT_SECRET_KEY']
  jwt.dispatch_requests = [['POST', %r{^/auth/login$}]]
  jwt.revocation_requests = [['DELETE', %r{^/auth/logout$}]]
  jwt.expiration_time = 15.minutes.to_i
end
```

---

## 📚 Documentação Swagger

Acesse a documentação interativa em:

```
http://localhost:3000/api-docs
```

A documentação é gerada automaticamente a partir dos testes RSpec com RSwag.

### Gerar/Atualizar Documentação

```bash
rails rswag:specs:swaggerize
```

---

## 🧪 Testes

### Executar todos os testes

```bash
bundle exec rspec
```

### Executar testes específicos

```bash
# Testes de request
bundle exec rspec spec/requests

# Testes de model
bundle exec rspec spec/models

# Teste específico
bundle exec rspec spec/requests/auth_spec.rb
```

### Cobertura de Testes

```bash
COVERAGE=true bundle exec rspec
open coverage/index.html
```

---

## 📈 Observabilidade

### Healthcheck

```bash
curl http://localhost:3000/health
```

### Logs Estruturados (Lograge)

```ruby
# config/environments/production.rb
config.lograge.enabled = true
config.lograge.formatter = Lograge::Formatters::Json.new
```

### Métricas (Prometheus - Opcional)

```ruby
# GET /metrics
# Expõe métricas para Prometheus
```

---


### Docker

```bash
docker-compose up -d
```

---

## 🛠️ Desenvolvimento

### Estrutura de Pastas

```
authify/
├── app/
│   ├── controllers/
│   │   ├── auth/          # Autenticação (signup, login, logout)
│   │   └── application_controller.rb
│   ├── models/
│   │   ├── user.rb
│   │   └── jwt_denylist.rb
│   └── serializers/       # Serialização JSON (opcional)
├── config/
│   ├── initializers/
│   │   └── devise.rb      # Configuração JWT
│   └── routes.rb
├── db/
│   └── migrate/
├── spec/
│   ├── requests/          # Testes de API
│   ├── models/            # Testes de models
│   └── swagger/           # Specs RSwag
└── swagger/               # Documentação OpenAPI gerada
```

### Comandos Úteis

```bash
# Console Rails
rails console

# Rotas
rails routes

# Gerar migration
rails g migration AddFieldToUsers field:string

# Rollback
rails db:rollback
```

---

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👨‍💻 Autor

**Seu Nome**
- GitHub: [@Flavio-LP](https://github.com/Flavio-LP)
- LinkedIn: [Flávio Pirola](https://www.linkedin.com/in/flavio-pirola/)

---

## 🙏 Agradecimentos

- [Devise](https://github.com/heartcombo/devise)
- [Devise-JWT](https://github.com/waiting-for-dev/devise-jwt)
- [RSwag](https://github.com/rswag/rswag)
- Comunidade Rails

---

## 📞 Suporte

Para dúvidas ou problemas, abra uma [issue](https://github.com/Flavio-LP/authify/issues).

---

<div align="center">

**⭐ Se este projeto foi útil, considere dar uma estrela!**

</div>