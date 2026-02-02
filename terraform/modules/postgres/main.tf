resource "docker_image" "postgres" {
  name = "${var.project_name}_postgres:15.8"

  build {
    context = var.build_context
  }
}

resource "docker_volume" "pgdata" {
  name = "${var.project_name}_pgdata"
}

resource "docker_container" "postgres" {
  name  = "${var.project_name}_postgres"
  image = docker_image.postgres.name

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]

  volumes {
    volume_name    = docker_volume.pgdata.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name    = var.db_network_name
    aliases = ["postgres"]
  }

  restart = "unless-stopped"
}
