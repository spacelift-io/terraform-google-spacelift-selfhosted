variable "create_compute_address_for_mqtt" {
  type        = bool
  description = "Whether to create a compute address for MQTT. It is meant to be used by Service of type LoadBalancer from the GKE cluster to expose the embedded MQTT server to the world. This is only required if you want to run worker outside of the GKE cluster."
}
