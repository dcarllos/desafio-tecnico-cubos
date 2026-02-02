output "container_name" {
  description = "Nome do container Postgres."
  value       = docker_container.postgres.name
}

output "hostname" {
  description = "Hostname (alias) do Postgres na rede interna."
  value       = "postgres"
}
