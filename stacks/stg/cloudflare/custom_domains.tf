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
}
