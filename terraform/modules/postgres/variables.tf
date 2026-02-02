variable "project_name" {
  type        = string
  description = "Prefixo do projeto."
}

variable "build_context" {
  type        = string
  description = "Diretório do Dockerfile do Postgres (build local)."
}

variable "db_network_name" {
  type        = string
  description = "Nome da rede interna do banco."
}

variable "db_name" {
  type        = string
  description = "Nome do banco."
}

variable "db_user" {
  type        = string
  description = "Usuário do banco."
}

variable "db_password" {
  type        = string
  description = "Senha do banco."
  sensitive   = true
}
