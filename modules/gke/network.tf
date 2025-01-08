# This module create a Cloud router & Cloud NAT is used to allow outbound traffic from k8s pods
# Only SNAT is allowed here, this should not be used for routing incoming traffic to pods.
module "gke-router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"
  project = var.project
  region  = var.region
  name    = "gke-router-${var.seed}"
  count   = var.enabled ? 1 : 0

  network = var.network.name
  nats = [{
    name                               = "gke-pods-nat"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [
      {
        name                    = var.subnetwork.id
        source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]
        secondary_ip_range_names = [
          var.subnetwork.secondary_ip_range[1].range_name,
        ]
      }
    ]
  }]
}
