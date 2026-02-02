resource "docker_image" "proxy" {
  name = "${var.project_name}_proxy:latest"

  build {
    context = var.build_context
  }
}

resource "docker_container" "proxy" {
  name  = "${var.project_name}_proxy"
  image = docker_image.proxy.name

  ports {
    internal = 80
    external = var.public_port
  }

  networks_advanced {
    name = var.public_network_name
  }

  networks_advanced {
    name = var.app_network_name
  }

  restart = "unless-stopped"
}
