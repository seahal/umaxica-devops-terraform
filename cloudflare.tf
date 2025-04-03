locals {
  environments = ["production", "staging"]
  regions      = ["jp", "root"]
  entities     = ["edge", "jit"]

  cloudflare_r2_bucket_combinations = [
    for env in local.environments : [
      for entity in local.entities : [
        for region in local.regions : {
          environment = env
          region      = region
          entity      = entity
          bucket_name = "umaxica-${env}-cloudflare-r2-asset-${entity}-${region}"
        }
    ]]
  ]

  flat_bucket_combinations = flatten(local.cloudflare_r2_bucket_combinations)
}

# Create bucket for Cloudflare
resource "cloudflare_r2_bucket" "umaxica_r2_buckets" {
  for_each = { for item in local.flat_bucket_combinations : item.bucket_name => item }

  account_id = var.cloudflare_account_id
  name       = each.value.bucket_name
  location   = "apac"
}


# Cloudflare workers which delives assets files of rails