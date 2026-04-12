locals {
  r2_buckets = {
    "umaxica-production-cloudflare-r2-asset-jit-jp" = {}
    "umaxica-production-cloudflare-r2-asset-jit-us" = {}
    "umaxica-production-cloudflare-r2-asset-jit-ww" = {}
  }
}

# =============================================================================
# R2 Buckets
# =============================================================================

resource "cloudflare_r2_bucket" "buckets" {
  for_each = local.r2_buckets

  account_id = var.account_id
  name       = each.key

  lifecycle {
    prevent_destroy = true
  }
}
