output "container_name" {
  description = "Nome do container backend."
  value       = docker_container.backend.name
}

output "hostname" {
  description = "Hostname (alias) do backend na rede de aplicação."
  value       = "backend"
}

output "internal_port" {
  description = "Porta interna do backend."
  value       = var.internal_port
}
