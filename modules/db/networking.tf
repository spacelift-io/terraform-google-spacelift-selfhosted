resource "google_compute_global_address" "database-private-ip" {
  name          = "spacelift-database-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.compute_network_id
}
