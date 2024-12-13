resource "google_compute_network" "default" {
  name                     = "spacelift-cluster-network"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

# This public v4 address is meant to be used by Ingresses from the GKE cluster to expose services to the world.
resource "google_compute_global_address" "gke-public-v4" {
  name         = "spacelift-gke-public-v4-${var.seed}"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

# This public v6 address is meant to be used by Ingresses from the GKE cluster to expose services to the world.
resource "google_compute_global_address" "gke-public-v6" {
  name         = "spacelift-gke-public-v6-${var.seed}"
  address_type = "EXTERNAL"
  ip_version   = "IPV6"
}
