variable "region" {
  description = "do not forget to set region"
  nullable = false
  type = string
  default = "ap-northeast-1"
}

variable "cloudflare_api_token" {
  description = "api token of cloudflare"
  nullable = false
  type = string
  default = ""
}