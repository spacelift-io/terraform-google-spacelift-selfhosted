output "mqtt_endpoint" {
  value       = var.enable_external_workers ? trimsuffix(google_dns_record_set.CNAME_mqtt[0].name, ".") : var.mqtt_service_alias
  description = "Address of the MQTT endpoint."
}
