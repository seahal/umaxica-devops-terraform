locals {
  workers = toset([
    "umaxica-apps-apex-app-apex",
    "umaxica-apps-edge-app-core",
    "umaxica-apps-edge-com-apex",
    "umaxica-apps-edge-com-core",
    "umaxica-apps-edge-net-apex",
    "umaxica-apps-edge-org-apex",
    "umaxica-apps-edge-org-core",
  ])
}

resource "cloudflare_workers_script" "workers" {
  for_each = local.workers

  account_id  = var.account_id
  script_name = each.key

  content            = "placeholder"
  compatibility_date = "2026-02-27"

  observability = {
    enabled            = true
    head_sampling_rate = 0.2
    logs = {
      enabled            = true
      head_sampling_rate = 0.2
      invocation_logs    = true
      persist            = true
    }
  }

  placement = {
    mode = "smart"
  }

  usage_model = "standard"

  lifecycle {
    # content: deployed via Wrangler, not Terraform
    # bindings: RATE_LIMITER (type "ratelimit") is not yet supported by the provider
    # compatibility_flags: varies per worker
    ignore_changes = [content, bindings, compatibility_flags]
  }
}
