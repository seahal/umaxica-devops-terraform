variable "gcp_project" {
  type        = string
  description = "GCP project ID to use for Google provider."
}

variable "region" {
  type        = string
  description = "Cloud region (e.g. asia-northeast1, ap-northeast-1, etc.)."
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token with permissions to manage zones/settings."
  sensitive   = true
}

