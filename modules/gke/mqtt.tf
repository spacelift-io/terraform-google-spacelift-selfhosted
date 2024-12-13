resource "google_compute_address" "gke-mqtt-v4" {
  count = var.create_compute_address_for_mqtt ? 1 : 0

  name         = "gke-mqtt-v4-${var.seed}"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

resource "google_compute_address" "gke-mqtt-v6" {
  count = var.create_compute_address_for_mqtt ? 1 : 0

  name               = "gke-mqtt-v6-${var.seed}"
  address_type       = "EXTERNAL"
  ip_version         = "IPV6"
  ipv6_endpoint_type = "NETLB"
  subnetwork         = google_compute_subnetwork.default.id
}
