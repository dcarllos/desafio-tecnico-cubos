resource "docker_image" "frontend" {
  name = "${var.project_name}_frontend:latest"

  build {
    context = var.build_context
  }
}

resource "docker_container" "frontend" {
  name  = "${var.project_name}_frontend"
  image = docker_image.frontend.name

  # Não expõe porta no host: o acesso externo ocorre apenas via proxy.

  networks_advanced {
    name    = var.app_network_name
    aliases = ["frontend"]
  }

  restart = "unless-stopped"
}
