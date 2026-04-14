variable "fastly_api_token" {
  description = "Fastly API token"
  type        = string
  sensitive   = true
}

variable "fastly_service_name" {
  description = "Fastly service name"
  type        = string
}
