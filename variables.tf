variable "region" {
  description = "do not forget to set region"
  nullable    = false
  type        = string
}


variable "cloudflare_tunsile_api_token" {
  description = "api token of cloudflare"
  nullable    = false
  type        = string
}

variable "cloudflare_api_token" {
  description = ""
  nullable    = false
  type        = string
}