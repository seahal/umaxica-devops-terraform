locals {
  zones = {
    "umaxica.app" = "689f76e1f7509c1aa8f223425b5d6a39"
    "umaxica.com" = "5d6e1d349e3c48b25feca13b497f9c99"
    "umaxica.net" = "d1c2e765f7b5c9b343f7e03a31d91ecf"
    "umaxica.org" = "771b6a675b8758959117a2874e828d21"
  }

  app_workers = toset([
    "umaxica-apps-edge-app-docs",
    "umaxica-apps-edge-app-help",
    "umaxica-apps-edge-app-news",
    "umaxica-apps-edge-com-news",
    "umaxica-apps-edge-org-news",
  ])

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

# =============================================================================
# Zones
# =============================================================================

resource "cloudflare_zone" "zones" {
  for_each = local.zones

  account = {
    id = var.account_id
  }
  name = each.key

  lifecycle {
    prevent_destroy = true
  }
}

import {
  for_each = local.zones
  to       = cloudflare_zone.zones[each.key]
  id       = each.value
}

# =============================================================================
# Workers
# =============================================================================

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

resource "cloudflare_worker" "app_workers" {
  for_each = local.app_workers

  account_id = var.account_id
  name       = each.key

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
}

resource "cloudflare_worker_version" "app_workers" {
  for_each = local.app_workers

  account_id = var.account_id
  worker_id  = cloudflare_worker.app_workers[each.key].id

  compatibility_date = "2026-02-27"
  main_module        = "index.js"

  modules = [{
    name         = "index.js"
    content_file = "${path.module}/../../../files/cloudflare-worker/index.js"
    content_type = "application/javascript+module"
  }]
}

resource "cloudflare_workers_deployment" "app_workers" {
  for_each = local.app_workers

  account_id  = var.account_id
  script_name = cloudflare_worker.app_workers[each.key].name
  strategy    = "percentage"

  versions = [{
    version_id = cloudflare_worker_version.app_workers[each.key].id
    percentage = 100
  }]
}
