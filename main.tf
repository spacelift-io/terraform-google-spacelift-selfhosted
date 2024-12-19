resource "random_id" "seed" {
  byte_length = 4
}

locals {
  network                   = var.enable_network ? module.network.network : var.network
  subnetwork                = var.enable_network ? module.network.subnetwork : var.subnetwork
  gke_service_account_email = var.enable_gke ? module.iam.gke_service_account_email : var.node_service_account.email
}

module "iam" {
  source = "./modules/iam"
  seed   = random_id.seed.hex

  enable_gke               = var.enable_gke
  node_service_account     = var.node_service_account
  app_service_account_name = var.app_service_account_name
  project                  = var.project
}

module "artifacts" {
  source     = "./modules/artifacts"
  depends_on = [module.iam]
  seed       = random_id.seed.hex

  enable_external_workers = var.enable_external_workers
}

module "network" {
  source     = "./modules/network"
  depends_on = [module.iam]
  seed       = random_id.seed.hex
  enabled    = var.enable_network

  enable_external_workers         = var.enable_external_workers
  ip_cidr_range                   = var.ip_cidr_range
  region                          = var.region
  secondary_ip_range_for_pods     = var.secondary_ip_range_for_pods
  secondary_ip_range_for_services = var.secondary_ip_range_for_services
}

module "gke" {
  source  = "./modules/gke"
  seed    = random_id.seed.hex
  enabled = var.enable_gke

  app_service_account_name   = var.app_service_account_name
  backend_service_account_id = module.iam.backend_service_account_id
  gke_service_account_email  = local.gke_service_account_email
  k8s_namespace              = var.k8s_namespace
  project                    = var.project
  region                     = var.region
  network                    = local.network
  subnetwork                 = local.subnetwork
}

module "db" {
  source = "./modules/db"
  seed   = random_id.seed.hex
  count  = var.enable_database ? 1 : 0

  backend_service_account_email = module.iam.backend_service_account_email
  database_deletion_protection  = var.database_deletion_protection
  database_edition              = var.database_edition
  database_tier                 = var.database_tier
  network                       = local.network
  project                       = var.project
}

module "storage" {
  source = "./modules/storage"
  seed   = random_id.seed.hex

  backend_service_account_email = module.iam.backend_service_account_email
  cors_origins                  = ["https://${var.website_domain}"]
  project                       = var.project
  region                        = var.region
}

module "dns" {
  source = "./modules/dns"
  seed   = random_id.seed.hex

  network                 = local.network
  enable_external_workers = var.enable_external_workers
  gke_public_v4_address   = module.network.gke_public_v4_address
  gke_public_v6_address   = module.network.gke_public_v6_address
  k8s_namespace           = var.k8s_namespace
  website_domain          = var.website_domain
}
