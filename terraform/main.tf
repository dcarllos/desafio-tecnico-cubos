provider "docker" {}

locals {
  repo_root = abspath("${path.root}/..")
}

# Redes:
# - public: contato com o usuário (proxy expõe porta para o host)
# - app: rede interna entre proxy <-> frontend/backend
# - db: rede interna restrita entre backend <-> postgres
resource "docker_network" "public" {
  name     = "${var.project_name}_public"
  internal = false
}

resource "docker_network" "app" {
  name     = "${var.project_name}_app"
  internal = true
}

resource "docker_network" "db" {
  name     = "${var.project_name}_db"
  internal = true
}

module "postgres" {
  source = "./modules/postgres"

  project_name     = var.project_name
  db_network_name  = docker_network.db.name

  build_context    = "${local.repo_root}/postgres"

  db_name          = var.db_name
  db_user          = var.db_user
  db_password      = var.db_password
}

module "backend" {
  source = "./modules/backend"

  project_name    = var.project_name
  app_network_name = docker_network.app.name
  db_network_name  = docker_network.db.name

  build_context   = "${local.repo_root}/backend"

  db_host         = module.postgres.hostname
  db_name         = var.db_name
  db_user         = var.db_user
  db_password     = var.db_password

  depends_on      = [module.postgres]
}

module "frontend" {
  source = "./modules/frontend"

  project_name     = var.project_name
  app_network_name = docker_network.app.name

  build_context    = "${local.repo_root}/frontend"
}

module "proxy" {
  source = "./modules/proxy"

  project_name      = var.project_name
  public_network_name = docker_network.public.name
  app_network_name    = docker_network.app.name

  build_context     = "${local.repo_root}/proxy"

  public_port       = var.public_port

  depends_on        = [module.frontend, module.backend]
}
