variable "region" {
  description = "do not forget to set region"
  nullable    = false
  type        = string
}

variable "environment" {
  description = "The target environment"
  type        = string
  default     = "production"
  validation {
    condition     = contains(["production", "staging"], var.environment)
    error_message = "Environment must be either 'staging' or 'production'."
  }
}

# variable "cloudflare_tunsile_api_token" {
#   description = "api token of cloudflare"
#   nullable    = true
#   type        = string
# }

# variable "cloudflare_api_token" {
#   description = ""
#   nullable    = true
#   type        = string
# }

variable "cloudflare_api_token" {
  default     = ""
  type        = string
  description = "Cloudflare API Token"
}

variable "cloudflare_account_id" {
  default     = ""
  description = "cloudflare account id"
  type        = string
}