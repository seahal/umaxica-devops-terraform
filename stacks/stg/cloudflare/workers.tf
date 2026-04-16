locals {
  workers = merge(
    {
      for zone in ["app", "com", "org", "net"] :
      "umaxica-apps-edge-${zone}-apex" => {}
    },
    {
      for zone in ["app", "com", "org"] :
      "umaxica-apps-edge-${zone}-core" => {}
    }
  )

  worker_observability = {
    for name in keys(local.workers) :
    name => {
      enabled            = false
      head_sampling_rate = 1
      logs = {
        enabled            = true
        head_sampling_rate = 0.2
        invocation_logs    = true
        persist            = true
      }
      traces = {
        enabled            = true
        head_sampling_rate = 0.2
      }
    }
  }

  worker_subdomain_enabled = {
    for name in keys(local.workers) :
    name => name != "umaxica-apps-edge-app-apex" && name != "umaxica-apps-edge-com-apex" && name != "umaxica-apps-edge-net-apex" && name != "umaxica-apps-edge-org-apex"
  }

  worker_tags = {
    for name in keys(local.workers) :
    name => concat(
      contains([
        "umaxica-apps-edge-app-apex",
        "umaxica-apps-edge-app-core",
        "umaxica-apps-edge-com-apex",
        "umaxica-apps-edge-com-core",
        "umaxica-apps-edge-net-apex",
        "umaxica-apps-edge-org-core",
      ], name) ? ["cf:environment=production"] : [],
      ["cf:service=${name}"],
    )
  }
}

# =============================================================================
# Workers
# =============================================================================

resource "cloudflare_worker" "workers" {
  for_each = local.workers

  account_id = var.account_id
  name       = each.key

  observability = local.worker_observability[each.key]

  subdomain = {
    enabled          = local.worker_subdomain_enabled[each.key]
    previews_enabled = true
  }

  tags = local.worker_tags[each.key]

  lifecycle {
    prevent_destroy = true
  }
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-app-apex"]
  id = "2b7d818500f34699bf937d717d8b6e43"
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-app-core"]
  id = "5acaaaa3264e47d789b8443b8925c4ef"
}


import {
  to = cloudflare_worker.workers["umaxica-apps-edge-com-apex"]
  id = "303f82d03fb54f04b7823635adc83fdc"
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-com-core"]
  id = "392d8e438e71487083c1cd59ca953b70"
}


import {
  to = cloudflare_worker.workers["umaxica-apps-edge-net-apex"]
  id = "577b36c1fab041d7a6e456e5eb2e6a59"
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-org-apex"]
  id = "e622ff40f34f423f8a364fdcb71a4002"
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-org-core"]
  id = "12df970e8b604ad2959d2089c4ff44fd"
}

