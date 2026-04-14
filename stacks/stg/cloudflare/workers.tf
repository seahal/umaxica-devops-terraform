locals {
  workers = merge(
    {
      for zone in ["app", "com", "org", "net"] :
      "umaxica-apps-edge-${zone}-apex" => {}
    },
    {
      for zone in ["app", "com", "org"] :
      "umaxica-apps-edge-${zone}-core" => {}
    },
    {
      for zone in ["app", "com", "org"] :
      "umaxica-apps-edge-${zone}-docs" => {}
    },
    {
      for zone in ["app", "com", "org"] :
      "umaxica-apps-edge-${zone}-help" => {}
    },
    {
      for zone in ["app", "com", "org"] :
      "umaxica-apps-edge-${zone}-news" => {}
    }
  )

  worker_observability = {
    for name in keys(local.workers) :
    name => {
      enabled            = name != "umaxica-apps-edge-com-help"
      head_sampling_rate = name == "umaxica-apps-edge-com-help" ? 1 : 0.2
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
        "umaxica-apps-edge-com-help",
        "umaxica-apps-edge-net-apex",
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
    ignore_changes = [
      references,
      updated_on,
    ]
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
  to = cloudflare_worker.workers["umaxica-apps-edge-app-docs"]
  id = "a57aa87c60804ca6ac3fefd580f64a3b"
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-app-help"]
  id = "321a87daa8cc4e7e9067f4e5f1ff351a"
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-app-news"]
  id = "d55cfb765308440680de7375cada7888"
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
  to = cloudflare_worker.workers["umaxica-apps-edge-com-docs"]
  id = "91cfa3c1ce3746f799515cee950f3161"
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-com-help"]
  id = "f957280c1a744ed382b1bd6360044136"
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-com-news"]
  id = "bcd091417e624f1d8a4f52446d1f81f1"
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

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-org-docs"]
  id = "8b89830e10024b2cbc1a42ab8327a7cf"
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-org-help"]
  id = "296ace2409df4105a2a3578ee59f8c0f"
}

import {
  to = cloudflare_worker.workers["umaxica-apps-edge-org-news"]
  id = "56d9c2b918724f369d806b7afd72b4eb"
}
