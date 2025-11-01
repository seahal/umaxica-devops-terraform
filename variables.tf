variable "region" {
  description = "do not forget to set region"
  nullable    = false
  type        = string
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
  description = "Cloudflare API Token"
  default     = ""
  type        = string
}

variable "cloudflare_account_id" {
  description = "cloudflare account id"
  default     = ""
  type        = string
}
