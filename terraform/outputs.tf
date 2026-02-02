output "app_url" {
  description = "URL da aplicação (frontend via proxy)."
  value       = "http://localhost:${var.public_port}"
}

output "containers" {
  description = "Nomes/hostnames utilizados na rede interna."
  value = {
    proxy    = module.proxy.container_name
    frontend = module.frontend.container_name
    backend  = module.backend.container_name
    postgres = module.postgres.container_name
  }
}
