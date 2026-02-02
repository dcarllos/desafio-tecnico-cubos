output "container_name" {
  description = "Nome do container frontend."
  value       = docker_container.frontend.name
}

output "hostname" {
  description = "Hostname (alias) do frontend na rede de aplicação."
  value       = "frontend"
}

output "internal_port" {
  description = "Porta interna do frontend."
  value       = var.internal_port
}
