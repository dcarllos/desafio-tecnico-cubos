variable "project_name" {
  type        = string
  description = "Prefixo do projeto."
}

variable "build_context" {
  type        = string
  description = "Diretório do Dockerfile do proxy (build local)."
}

variable "public_network_name" {
  type        = string
  description = "Nome da rede externa (contato com o usuário)."
}

variable "app_network_name" {
  type        = string
  description = "Nome da rede interna da aplicação."
}

variable "public_port" {
  type        = number
  description = "Porta do host exposta pelo proxy."
  default     = 80
}
