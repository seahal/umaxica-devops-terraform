locals {
  environments = ["production"]
  regions = ["jp", "root"]
  entities = ["edge", "jit"]
  
  # Explicitly create all combinations
  cloudflare_r2_bucket_combinations = distinct(flatten([
    for env in local.environments : [
      for entity in local.entities : [
        for region in local.regions : {
          environment = env
          region = region
          entity = entity
          bucket_name = "umaxica-${env}-cloudflare-r2-asset-${entity}-${region}"
        }
      ]
    ]
  ]))
}

resource "cloudflare_r2_bucket" "umaxica_cloudflare_r2_asset_bucket" {
  for_each = { for item in local.cloudflare_r2_bucket_combinations : item.bucket_name => item }
  account_id = var.cloudflare_account_id
  name = each.value.bucket_name
  location = "apac"
}

# Optional: Output to verify bucket names
output "bucket_names" {
  value = [for bucket in cloudflare_r2_bucket.umaxica_cloudflare_r2_asset_bucket : bucket.name]
}