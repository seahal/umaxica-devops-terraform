variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
  default     = "c90999d8a4039c63d02b7a7b1545d211"
}

variable "cloudflare_workers_builds_repo_connection_uuid" {
  description = "Cloudflare Workers Builds repo connection UUID"
  type        = string
  default     = "5950fe45-4ddd-4b50-bcdd-d0a45efe08a8"
  nullable    = true
}

variable "cloudflare_workers_builds_workers" {
  description = "Worker names to sync Cloudflare Workers Builds for. Null enables all workers."
  type        = list(string)
  default     = null
  nullable    = true
}
