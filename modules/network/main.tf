resource "google_compute_network" "default" {
  name                     = "spacelift-cluster-network-${var.seed}"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
  count                    = var.enabled ? 1 : 0
}

resource "google_compute_subnetwork" "default" {
  name  = "spacelift-gke-cluster-subnetwork"
  count = var.enabled ? 1 : 0

  ip_cidr_range = var.ip_cidr_range
  region        = var.region

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"

  network = google_compute_network.default[0].id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.secondary_ip_range_for_services
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = var.secondary_ip_range_for_pods
  }
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

# This public v4 address is meant to be used by Service of type LoadBalancer from the GKE cluster
# to expose the embedded MQTT server to the world. This is only required if we want to run worker outside of the
# GKE cluster.
resource "google_compute_address" "mqtt-v4" {
  count        = (var.enable_external_workers && var.enabled) ? 1 : 0
  name         = "gke-mqtt-v4-${var.seed}"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

# This public v6 address is meant to be used by Service of type LoadBalancer from the GKE cluster
# to expose the embedded MQTT server to the world. This is only required if we want to run worker outside of the
# GKE cluster.
resource "google_compute_address" "mqtt-v6" {
  count              = (var.enable_external_workers && var.enabled) ? 1 : 0
  name               = "gke-mqtt-v6-${var.seed}"
  address_type       = "EXTERNAL"
  ip_version         = "IPV6"
  ipv6_endpoint_type = "NETLB"
  subnetwork         = google_compute_subnetwork.default[0].id
}

# Global IPv4 address for VCS Gateway Ingress
resource "google_compute_global_address" "vcs-gateway" {
  count        = var.enable_vcs_gateway ? 1 : 0
  name         = "gke-vcs-gateway-${var.seed}"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}
