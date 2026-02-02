variable "project_name" {
  type        = string
  description = "Prefixo do projeto."
}

variable "build_context" {
  type        = string
  description = "Diretório do Dockerfile do frontend (build local)."
}

variable "app_network_name" {
  type        = string
  description = "Nome da rede interna de aplicação (proxy <-> frontend/backend)."
}

variable "internal_port" {
  type        = number
  description = "Porta interna do frontend."
  default     = 80
}
