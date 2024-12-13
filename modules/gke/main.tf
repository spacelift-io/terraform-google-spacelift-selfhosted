resource "google_container_cluster" "spacelift" {
  name = "spacelift-${var.seed}"

  location                 = var.region
  enable_autopilot         = true
  enable_l4_ilb_subsetting = true

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = var.gke_service_account_email
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }

  network    = var.compute_network_id
  subnetwork = google_compute_subnetwork.default.self_link

  private_cluster_config {
    # This prevents nodes to be assigned any external IP that can be routed on the internet
    enable_private_nodes = true
  }

  ip_allocation_policy {
    stack_type                    = "IPV4_IPV6"
    services_secondary_range_name = google_compute_subnetwork.default.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.default.secondary_ip_range[1].range_name
  }

  # Set `deletion_protection` to `true` will ensure that one cannot
  # accidentally delete this instance by use of Terraform.
  deletion_protection = false
}
