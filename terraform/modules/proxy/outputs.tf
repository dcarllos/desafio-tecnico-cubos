output "container_name" {
  description = "Nome do container proxy."
  value       = docker_container.proxy.name
}
