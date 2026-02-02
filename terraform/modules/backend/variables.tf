variable "project_name" {
  type        = string
  description = "Prefixo do projeto."
}

variable "build_context" {
  type        = string
  description = "Diretório do Dockerfile do backend (build local)."
}

variable "app_network_name" {
  type        = string
  description = "Nome da rede interna de aplicação (proxy <-> frontend/backend)."
}

variable "db_network_name" {
  type        = string
  description = "Nome da rede interna do banco (backend <-> postgres)."
}

variable "internal_port" {
  type        = number
  description = "Porta interna do backend."
  default     = 3000
}

variable "db_host" {
  type        = string
  description = "Hostname do Postgres na rede do banco."
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

variable "db_port" {
  type        = number
  description = "Porta do Postgres."
  default     = 5432
}
