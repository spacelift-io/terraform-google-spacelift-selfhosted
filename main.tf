resource "random_id" "seed" {
  byte_length = 4
}

module "iam" {
  source = "./modules/iam"
  seed   = random_id.seed.hex

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

  enable_external_workers         = var.enable_external_workers
  ip_cidr_range                   = var.ip_cidr_range
  secondary_ip_range_for_pods     = var.secondary_ip_range_for_pods
  secondary_ip_range_for_services = var.secondary_ip_range_for_services
  region                          = var.region
}

module "gke" {
  source = "./modules/gke"
  seed   = random_id.seed.hex

  app_service_account_name   = var.app_service_account_name
  backend_service_account_id = module.iam.backend_service_account_id
  compute_network_id         = module.network.network_id
  subnetwork                 = module.network.subnetwork
  pods_ip_range_name         = module.network.pods_ip_range_name
  services_ip_range_name     = module.network.services_ip_range_name
  compute_network_name       = module.network.network_name
  gke_service_account_email  = module.iam.gke_service_account_email
  k8s_namespace              = var.k8s_namespace
  project                    = var.project
  region                     = var.region
}

module "db" {
  source = "./modules/db"
  seed   = random_id.seed.hex

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
  seed   = random_id.seed.hex

  backend_service_account_email = module.iam.backend_service_account_email
  cors_origins                  = ["https://${var.website_domain}"]
  project                       = var.project
  region                        = var.region
}

module "dns" {
  source = "./modules/dns"
  seed   = random_id.seed.hex

  enable_external_workers = var.enable_external_workers
  website_domain          = var.website_domain
  compute_network_id      = module.network.network_id
  gke_public_v4_address   = module.network.gke_public_v4_address
  gke_public_v6_address   = module.network.gke_public_v6_address
}
