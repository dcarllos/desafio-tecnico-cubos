variable "project_name" {
  type        = string
  description = "Prefixo para nomear recursos do stack."
  default     = "devops_challenge"
}

variable "public_port" {
  type        = number
  description = "Porta externa exposta pelo proxy (Nginx)."
  default     = 80
}

variable "db_name" {
  type        = string
  description = "Nome do banco."
  default     = "appdb"
}

variable "db_user" {
  type        = string
  description = "Usuário do banco."
  default     = "appuser"
}

variable "db_password" {
  type        = string
  description = "Senha do banco."
  sensitive   = true
  default     = "apppass"
}
