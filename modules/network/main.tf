resource "google_compute_network" "default" {
  name                     = "spacelift-cluster-network"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_global_address" "database-private-ip" {
  name          = "spacelift-database-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.default.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.database-private-ip.name]
}

# This public v4 address is meant to be used by Ingresses from the GKE cluster to expose services to the world.
resource "google_compute_global_address" "gke-public-v4" {
  name         = "spacelift-gke-public-v4"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

# This public v6 address is meant to be used by Ingresses from the GKE cluster to expose services to the world.
resource "google_compute_global_address" "gke-public-v6" {
  name         = "spacelift-gke-public-v6"
  address_type = "EXTERNAL"
  ip_version   = "IPV6"
}
