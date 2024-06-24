# MicroService Auth

Microserviço de usuários em Ruby on Rails que implementa operações CRUD, geração de tokens seguros utilizando JWT e troca de senha utilizando PostgreSQL no formato de API REST.

## Funcionalidades

- Registro de novo usuário e token especifico JWT;
- Login de usuário e partir da validação das respectivas credênciais;
- Atualização de usuário;
- Remoção de Usuário;
- Leitura de usuário;
- Middleware para *autorização* de rotas protegidas.

## Configuração

### Pré-requisitos

- Ruby 3.x
- Rails 6.x
- PostgreSQL

### Instalação

1. Clone o repositório:

   ```sh
   git clone git@github.com:Erickw/microservice_auth.git
   cd microservice_auth
   ```

2. Instale as dependências:

   ```sh
   bundle install
   ```

3. Configure o banco de dados:

   ```sh
   rails db:create
   rails db:migrate
   ```

4. Configure as variáveis de ambiente:

   Crie um arquivo `.env` na raiz do projeto e defina as variáveis abaixo, para evitar inconsistências,
   também é recomendado atualizar os arquivos `.env.test.local` e `.env.development.local` com seus valores.

   ```env
   SECRET_KEY_BASE
   DATABASE_USERNAME
   DATABASE_PASSWORD
   SECRET_KEY_BASE
   JWT_EXPIRE_HOURS
   RAILS_ENV
   ```
     Para definir o periodo de expiração padrão do token em horas, basta preencher a váriavel `JWT_EXPIRE_HOURS` com um valor inteiro.
## Testes

### Executando Testes

- Para executar os testes, rode no terminal:

```sh
bundle exec rspec
```

- O projeto atualmente conta com 94.2% de cobertura de testes de acordo com a gem [Simplecov](https://github.com/simplecov-ruby/simplecov).

![image](https://github.com/Erickw/microservice_auth/assets/12042480/ef05d768-c067-4114-8d2b-0f956696af59)


## Uso

#### Execute o servidor localmente com o seguinte comando:

```sh
bundle exec rails s
```

### Endpoints Autenticação

#### Sign Up

- **URL:** `/signup`
- **Método:** `POST`
- **Descrição:** Cria um novo usuário.

**Request:**

```sh
curl -X POST http://localhost:3000/signup -H "Content-Type: application/json" -d '{"user":{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password",
  "password_confirmation": "password"
}}'
```

**Response:**

```json
{
  "message": "Account created successfully",
    "token": {
        "token": "eyJhbGciOiJIUzI1NiJ9...",
        "exp": "2024-06-21T14:52:00Z"
    }
}
```

#### Sign In

- **URL:** `/signin`
- **Método:** `POST`
- **Descrição:** Autentica um usuário e gera um token.

**Request:**

```sh
curl -X POST http://localhost:3000/signin -H "Content-Type: application/json" -d '{
  "email": "john@example.com",
  "password": "password"
}'
```

**Response:**

```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "exp": "2024-06-22T14:52:00Z"
}
```

**Erros Possíveis:**

- **Usuário não encontrado:**

  ```json
  {
    "error": "User not found"
  }
  ```

- **Credenciais inválidas:**

  ```json
  {
    "error": "Invalid email or password"
  }
  ```

- **Token inválido:**

  ```json
  {
    "error": "Signature verification failed"
  }
  ```

- **Token expirado:**

  ```json
  {
    "error": "Signature has expired"
  }
  ```

#### Reset Password

- **URL:** `/users/reset_password`
- **Método:** `POST`
- **Descrição:** Redefine a senha de um usuário.

**Request:**

```sh
curl --location 'http://127.0.0.1:3000/reset_password/' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <TOKEN>' \
--data-raw '{
    "email": "john@example.com",
    "password": "password123",
    "new_password": "password321"
}'
```

**Response:**

```json
{
  "message": "Password updated successfully"
}
```

### Endpoints Usuários

#### Show User

- **URL:** `/users/:id`
- **Método:** `GET`
- **Descrição:** Retorna o usuário de id solicitado.

**Request:**

```sh
curl --location 'http://localhost:3000/users/1' \
--header 'Authorization: Bearer <TOKEN>'
```

**Response:**

```json
{
    "id": 1,
    "name": "John",
    "password_digest": "$2a$12$bdj7cL0YB9FT9VaOdnFLB.XD6hEMN7GSjSP8JfwXA.Ib74IQ7tCze",
    "email": "john@example.com",
    "created_at": "2024-06-24T02:42:06.529Z",
    "updated_at": "2024-06-24T02:42:06.529Z"
}
```
#### Update User

- **URL:** `/users/users/:id`
- **Método:** `POST`
- **Descrição:** Atualiza os parâmetros enviados de um usuário.

**Request:**

```sh
curl --location --request PATCH 'http://localhost:3000/users/8' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <TOKEN>' \
--data '{
    "name": "João"
}'
```

**Response:**

```json
{
    "name": "João",
    "id": 8,
    "email": "john@example.com",
    "password_digest": "$2a$12$1skkrMa5ZDRyYbICj5mG0eqj53bRLm8SvfXideCZ3kWa7wbbYQUVq",
    "created_at": "2024-06-24T02:42:06.529Z",
    "updated_at": "2024-06-24T02:57:28.825Z"
}
```

#### Destroy User

- **URL:** `/users/users/:id`
- **Método:** `DELETE`
- **Descrição:** Remove um usuário a partir do id da requisição.

**Request:**

```sh
curl --location --request DELETE 'http://localhost:3000/users/8' \
--header 'Authorization: Bearer <TOKEN>'
```

**Response:**

No Content

