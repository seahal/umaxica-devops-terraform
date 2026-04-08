locals {
  workers = toset([
    # {app,com,org} x {apex,core,docs,help,news}
    "umaxica-apps-edge-app-apex",
    "umaxica-apps-edge-app-core",
    "umaxica-apps-edge-app-docs",
    "umaxica-apps-edge-app-help",
    "umaxica-apps-edge-app-news",
    "umaxica-apps-edge-com-apex",
    "umaxica-apps-edge-com-core",
    "umaxica-apps-edge-com-docs",
    "umaxica-apps-edge-com-help",
    "umaxica-apps-edge-com-news",
    "umaxica-apps-edge-org-apex",
    "umaxica-apps-edge-org-core",
    "umaxica-apps-edge-org-docs",
    "umaxica-apps-edge-org-help",
    "umaxica-apps-edge-org-news",
    # net x {apex}
    "umaxica-apps-edge-net-apex",
  ])
}

# =============================================================================
# Workers
# =============================================================================

resource "cloudflare_worker" "workers" {
  for_each = local.workers

  account_id = var.account_id
  name       = each.key

  observability = {
    enabled            = true
    head_sampling_rate = 1
    logs = {
      enabled            = true
      head_sampling_rate = 1
      invocation_logs    = true
      persist            = true
    }
  }

  subdomain = {
    enabled          = false
    previews_enabled = false
  }

  tags = [
    "cf:environment=production",
    "cf:service=${each.key}",
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_worker_version" "workers" {
  for_each = local.workers

  account_id = var.account_id
  worker_id  = cloudflare_worker.workers[each.key].id

  compatibility_date = "2026-02-27"
  main_module        = "index.js"

  modules = [{
    name         = "index.js"
    content_file = "${path.module}/../../../files/cloudflare-worker/index.js"
    content_type = "application/javascript+module"
  }]
}

resource "cloudflare_workers_deployment" "workers" {
  for_each = local.workers

  account_id  = var.account_id
  script_name = cloudflare_worker.workers[each.key].name
  strategy    = "percentage"

  versions = [{
    version_id = cloudflare_worker_version.workers[each.key].id
    percentage = 100
  }]
}
