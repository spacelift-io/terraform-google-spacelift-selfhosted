module "iam" {
  source = "./modules/iam"

  app_service_account_name = var.app_service_account_name
  project                  = var.project
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

  app_service_account_name        = var.app_service_account_name
  backend_service_account_id      = module.iam.backend_service_account_id
  compute_network_id              = module.network.network_id
  compute_network_name            = module.network.network_name
  create_compute_address_for_mqtt = var.create_compute_address_for_mqtt
  gke_service_account_email       = module.iam.gke_service_account_email
  ip_cidr_range                   = var.ip_cidr_range
  k8s_namespace                   = var.k8s_namespace
  project                         = var.project
  region                          = var.region
  secondary_ip_range_for_pods     = var.secondary_ip_range_for_pods
  secondary_ip_range_for_services = var.secondary_ip_range_for_services
}

module "db" {
  source = "./modules/db"

  backend_service_account_email = module.iam.backend_service_account_email
  compute_network_id            = module.network.network_id
  database_deletion_protection  = var.database_deletion_protection
  database_edition              = var.database_edition
  database_tier                 = var.database_tier
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
