locals {
  apex_worker_custom_domains = {
    for zone, worker in {
      app = "umaxica-apps-edge-app-apex"
      com = "umaxica-apps-edge-com-apex"
      net = "umaxica-apps-edge-net-apex"
      org = "umaxica-apps-edge-org-apex"
      } : worker => {
      hostname  = "umaxica.${zone}"
      service   = worker
      zone_name = "umaxica.${zone}"
    }
  }

  service_domains = merge([
    for zone in ["app", "com", "org"] : {
      "umaxica-apps-edge-${zone}-core" = {
        service   = "umaxica-apps-edge-${zone}-core"
        hostname  = "jp.umaxica.${zone}"
        zone_name = "umaxica.${zone}"
      }
      "umaxica-apps-edge-${zone}-core-us" = {
        service   = "umaxica-apps-edge-${zone}-core"
        hostname  = "us.umaxica.${zone}"
        zone_name = "umaxica.${zone}"
      }
      "umaxica-apps-edge-${zone}-jump" = {
        service   = "umaxica-apps-edge-${zone}-jump"
        hostname  = "jump.umaxica.${zone}"
        zone_name = "umaxica.${zone}"
      }
    }
  ]...)

  worker_custom_domains = merge(local.apex_worker_custom_domains, local.service_domains)
}

# =============================================================================
# Worker Domains
# =============================================================================

resource "cloudflare_workers_custom_domain" "workers" {
  for_each = local.worker_custom_domains

  account_id = var.account_id
  # Keep the deprecated field for now; removing it forces replacement in the current provider version.
  environment = "production"
  hostname    = each.value.hostname
  service     = each.value.service
  zone_id     = local.zones[each.value.zone_name]

  lifecycle {
    prevent_destroy = true
  }
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-app-apex"]
  id = "c508b1281411d1963c0927702990517882b6b826"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-app-core"]
  id = "b4640f7fa8c798b2602c3fc4b43559e083adb2c8"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-app-core-us"]
  id = "63f4929bae4f7abb83749a7592a68918b0bfc5fa"
}


import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-com-apex"]
  id = "2ad3d17ce9e919fdc9ac1843c34306bb995c4bf3"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-com-core"]
  id = "601564de509a4d1df0da0fc860dda1f23230e72f"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-com-core-us"]
  id = "a6039e027d2dc7a60f95f41d4335d3cb87a3dd1d"
}


import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-net-apex"]
  id = "e66ca279a5ab16c36fcc21dc349292634a7c477b"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-org-apex"]
  id = "29f7ecd61cee342d129b35b2a046e2fc62576250"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-org-core"]
  id = "c2ca1cd0a3653c0a4f2a5a65abefa676f583de34"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-org-core-us"]
  id = "d8b4ae499b3ba61fde7ab51accef8972827e87a0"
}

