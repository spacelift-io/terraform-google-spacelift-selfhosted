locals {
  dns_name = join(".", slice(split(".", var.website_domain), length(split(".", var.website_domain))-2, length(split(".", var.website_domain))))
  count = var.enable_external_workers ? 1 : 0
}

resource "google_dns_managed_zone" "main" {
  count = local.count
  name        = "${replace(local.dns_name, ".", "-")}-${var.seed}"
  dns_name    = "${local.dns_name}."

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = var.compute_network_id
    }
  }
}

resource "google_dns_record_set" "CNAME_mqtt" {
  count = local.count
  managed_zone = google_dns_managed_zone.main[0].name

  name = "${var.mqtt_subdomain}.${var.website_domain}."
  type = "CNAME"
  ttl  = 300

  rrdatas = [var.mqtt_service_alias]
}

resource "google_dns_record_set" "A_website_domain" {
  count = local.count
  managed_zone = google_dns_managed_zone.main[0].name

  name = "${var.website_domain}."
  type = "A"
  ttl  = 300

  rrdatas = [var.gke_public_v4_address]
}

resource "google_dns_record_set" "AAAA_website_domain" {
  count = local.count
  managed_zone = google_dns_managed_zone.main[0].name

  name = "${var.website_domain}."
  type = "AAAA"
  ttl  = 300

  rrdatas = [var.gke_public_v6_address]
}
