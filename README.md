# Desafio técnico - Cubos DevOps (Entrega)

Ambiente **local** (sem dependência de cloud paga) com:

- Proxy reverso **Nginx** (único serviço exposto ao usuário)
- Frontend (HTML) acessível via `/` no proxy
- Backend (Node.js) acessível **apenas** via `/api` no proxy
- Banco **PostgreSQL 15.8** com volume persistente e init SQL

A infraestrutura é criada via **Terraform** (Docker Provider). O Terraform:

1. cria redes Docker separando rede externa e redes internas
2. builda imagens Docker (frontend, backend, proxy e postgres)
3. cria contêineres e conecta cada um às redes necessárias
4. aplica política de reinício automático

---

## Arquitetura

```
Usuário (browser)
  │
  ▼
Host: http://localhost:<porta>
  │
  ▼
[Nginx Proxy]  (exposto)
  │
  ├── /     → Frontend (container: frontend)
  └── /api  → Backend  (container: backend, sem porta exposta)
                 │
                 ▼
             PostgreSQL 15.8 (container: postgres)
```

### Redes

- **public network (externa)**: somente o proxy participa e expõe porta no host.
- **app network (interna)**: proxy ↔ frontend/backend.
- **db network (interna restrita)**: backend ↔ postgres.

Isso atende ao requisito de ter **redes internas acessíveis apenas por certas aplicações**.

---

## Estrutura de diretórios

```
.
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── index.js
├── frontend/
│   ├── Dockerfile
│   └── index.html
├── proxy/
│   ├── Dockerfile
│   └── nginx.conf
├── postgres/
│   ├── Dockerfile
│   └── init.sql
├── sql/
│   └── script.sql (recurso original)
└── terraform/
    ├── versions.tf
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── modules/
        ├── backend/
        ├── frontend/
        ├── postgres/
        └── proxy/
```

---

## Dependências

- **Docker Engine / Docker Desktop** instalado e rodando
- **Terraform >= 1.5**

Verificação:

```bash
docker version
terraform version
```

> Observação (Windows): o mais simples é usar **Docker Desktop + WSL2** e executar o Terraform dentro do WSL ou usar somente o WSL2 e fazer tudo nele. Também funciona no PowerShell, desde que o Terraform consiga acessar o mesmo filesystem que o Docker está usando.

---

## Como iniciar (passo a passo)

1) Entre na pasta do Terraform:

```bash
cd terraform
```

2) Inicialize os providers:

```bash
terraform init
```

3) Suba o ambiente:

```bash
terraform apply
```

4) Acesse no navegador:

- `http://localhost:80` (ou a porta definida em `public_port`)

5) Clique no botão **"Verificar Backend e Banco"**.

---

## Como parar e remover tudo

```bash
cd terraform
terraform destroy
```

### Reset completo do banco (para rodar o init SQL novamente)

O Postgres usa um volume persistente. O script SQL roda automaticamente **apenas** quando o volume está vazio.

Para apagar os dados e permitir que o init rode novamente:

```bash
docker volume rm devops_challenge_pgdata
```

> Se você alterou `project_name`, o nome do volume muda (padrão: `devops_challenge_pgdata`).

---

## Variáveis de ambiente do banco

As credenciais/config do banco são passadas ao backend via variáveis de ambiente (configuradas no Terraform):

- `DB_HOST` (ex.: `postgres`)
- `DB_PORT` (ex.: `5432`)
- `DB_NAME` (ex.: `appdb`)
- `DB_USER` (ex.: `appuser`)
- `DB_PASSWORD` (ex.: `apppass`)

No Postgres, são usadas as variáveis padrões:

- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`

### Alterando via `terraform.tfvars`

Crie `terraform/terraform.tfvars`:

```hcl
project_name = "devops_challenge"
public_port  = 80

db_name     = "appdb"
db_user     = "appuser"
db_password = "minha_senha_forte"
```

---

## Como funciona o roteamento /api

O frontend chama `GET /api`. O proxy encaminha para o backend **sem expor o backend no host**.

- Browser → `http://localhost/api`
- Proxy → `http://backend:3000/api`

---

## Correções aplicadas nos recursos fornecidos

### Backend
O backend original tinha problemas de variáveis indefinidas e configuração de porta. Ajustes:

- uso de `PORT` em vez de `process.env.port`
- conexão com Postgres via `DB_HOST/DB_PORT/DB_NAME/DB_USER/DB_PASSWORD`
- uso de `pg.Pool` e query segura
- escuta em `0.0.0.0` para funcionar em container

### Frontend
O frontend original usava `fetch(..., { mode: 'no-cors' })`, o que impedia ler JSON. Ajustes:

- remoção do `no-cors`
- tratamento de erro amigável

---

## Troubleshooting rápido

Ver containers:

```bash
docker ps
```

Logs:

```bash
docker logs -f devops_challenge_proxy
docker logs -f devops_challenge_backend
docker logs -f devops_challenge_postgres
```

Recriar tudo do zero (incluindo reset do banco):

```bash
cd terraform
terraform destroy

docker volume rm devops_challenge_pgdata

terraform apply
```
