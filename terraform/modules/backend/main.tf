resource "docker_image" "backend" {
  name = "${var.project_name}_backend:latest"

  build {
    context = var.build_context
  }
}

resource "docker_container" "backend" {
  name  = "${var.project_name}_backend"
  image = docker_image.backend.name

  # Não expõe porta no host: acessível apenas via redes internas.

  env = [
    "PORT=${var.internal_port}",
    "DB_HOST=${var.db_host}",
    "DB_PORT=${var.db_port}",
    "DB_NAME=${var.db_name}",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}"
  ]

  networks_advanced {
    name    = var.app_network_name
    aliases = ["backend"]
  }

  networks_advanced {
    name = var.db_network_name
  }

  restart = "unless-stopped"
}
