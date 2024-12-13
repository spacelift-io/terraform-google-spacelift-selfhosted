resource "google_compute_subnetwork" "default" {
  name = "spacelift-gke-cluster-subnetwork"

  ip_cidr_range = var.ip_cidr_range
  region        = var.region

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"

  network = var.compute_network_id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.secondary_ip_range_for_services
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = var.secondary_ip_range_for_pods
  }
}

# This module create a Cloud router & Cloud NAT is used to allow outbound traffic from k8s pods
# Only SNAT is allowed here, this should not be used for routing incoming traffic to pods.
module "gke-router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  project = var.project
  region  = var.region
  name    = "gke-router-${var.seed}"

  network = var.compute_network_name
  nats = [{
    name                               = "gke-pods-nat"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [
      {
        name                    = google_compute_subnetwork.default.id
        source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
        secondary_ip_range_names = [
          google_compute_subnetwork.default.secondary_ip_range[1].range_name,
        ]
      }
    ]
  }]
}
