module "iam" {
  source  = "./modules/iam"
  project = var.project
}

module "artifacts" {
  source     = "./modules/artifacts"
  depends_on = [module.iam]
}

module "network" {
  source     = "./modules/network"
  depends_on = [module.iam]
}

module "gke" {
  source = "./modules/gke"

  compute_network_id        = module.network.network_id
  compute_network_name      = module.network.network_name
  gke_service_account_email = module.iam.gke_service_account_email
  project                   = var.project
  region                    = var.region
}

module "secrets" {
  source = "./modules/secrets"

  license_token = var.license_token
  region        = var.region
}

module "db" {
  source = "./modules/db"

  backend_service_account_email = module.iam.backend_service_account_email
  database_edition              = var.database_edition
  database_tier                 = var.database_tier
  db_root_password              = module.secrets.db_root_password
  network_link                  = module.network.network_link
  project                       = var.project
}

module "storage" {
  source = "./modules/storage"

  backend_service_account_email = module.iam.backend_service_account_email
  cors_origins                  = [var.website_domain]
  project                       = var.project
  region                        = var.region
}
