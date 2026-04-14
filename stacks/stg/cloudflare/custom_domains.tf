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
      "umaxica-apps-edge-${zone}-docs-jp" = {
        service   = "umaxica-apps-edge-${zone}-docs"
        hostname  = "docs-jp.umaxica.${zone}"
        zone_name = "umaxica.${zone}"
      }
      "umaxica-apps-edge-${zone}-help-jp" = {
        service   = "umaxica-apps-edge-${zone}-help"
        hostname  = "help-jp.umaxica.${zone}"
        zone_name = "umaxica.${zone}"
      }
      "umaxica-apps-edge-${zone}-news-jp" = {
        service   = "umaxica-apps-edge-${zone}-news"
        hostname  = "news-jp.umaxica.${zone}"
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

  account_id  = var.account_id
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
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-app-docs-jp"]
  id = "ec71dc987ed31d108b3b9783e58c7ea21c6b873a"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-app-help-jp"]
  id = "2cecc2443d8e8457db809c929eb5c877d31e6248"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-app-news-jp"]
  id = "419c148a4cea137463549dd05bf9e6a4897c0c51"
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
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-com-docs-jp"]
  id = "c6f6d9be9ecc15e84c5d7855aa38f0708372c5c4"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-com-help-jp"]
  id = "496b68bf5f87e12e6364895f3e74edb29ba39a02"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-com-news-jp"]
  id = "387bd8d85f45b8b5a8dca35fec6813b20f90ece8"
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

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-org-docs-jp"]
  id = "338a12b00c12dc21d26ff4f2147d096a21a2853b"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-org-help-jp"]
  id = "d848fdbda7d6997f62ec1079c3b22b0fa88c1a6d"
}

import {
  to = cloudflare_workers_custom_domain.workers["umaxica-apps-edge-org-news-jp"]
  id = "6fb3236c9e6751e6fcce34e73b5f86148aad11fb"
}
