locals {
  worker_custom_domains = {
    "umaxica-apps-edge-app-apex" = {
      service   = "umaxica-apps-edge-app-apex"
      hostname  = "umaxica.app"
      zone_name = "umaxica.app"
    }
    "umaxica-apps-edge-app-core" = {
      service   = "umaxica-apps-edge-app-core"
      hostname  = "jp.umaxica.app"
      zone_name = "umaxica.app"
    }
    "umaxica-apps-edge-app-core-us" = {
      service   = "umaxica-apps-edge-app-core"
      hostname  = "us.umaxica.app"
      zone_name = "umaxica.app"
    }
    "umaxica-apps-edge-app-docs-jp" = {
      service   = "umaxica-apps-edge-app-docs"
      hostname  = "docs-jp.umaxica.app"
      zone_name = "umaxica.app"
    }
    "umaxica-apps-edge-app-help-jp" = {
      service   = "umaxica-apps-edge-app-help"
      hostname  = "help-jp.umaxica.app"
      zone_name = "umaxica.app"
    }
    "umaxica-apps-edge-app-news-jp" = {
      service   = "umaxica-apps-edge-app-news"
      hostname  = "news-jp.umaxica.app"
      zone_name = "umaxica.app"
    }
    "umaxica-apps-edge-com-apex" = {
      service   = "umaxica-apps-edge-com-apex"
      hostname  = "umaxica.com"
      zone_name = "umaxica.com"
    }
    "umaxica-apps-edge-com-core" = {
      service   = "umaxica-apps-edge-com-core"
      hostname  = "jp.umaxica.com"
      zone_name = "umaxica.com"
    }
    "umaxica-apps-edge-com-core-us" = {
      service   = "umaxica-apps-edge-com-core"
      hostname  = "us.umaxica.com"
      zone_name = "umaxica.com"
    }
    "umaxica-apps-edge-com-docs-jp" = {
      service   = "umaxica-apps-edge-com-docs"
      hostname  = "docs-jp.umaxica.com"
      zone_name = "umaxica.com"
    }
    "umaxica-apps-edge-com-help-jp" = {
      service   = "umaxica-apps-edge-com-help"
      hostname  = "help-jp.umaxica.com"
      zone_name = "umaxica.com"
    }
    "umaxica-apps-edge-com-news-jp" = {
      service   = "umaxica-apps-edge-com-news"
      hostname  = "news-jp.umaxica.com"
      zone_name = "umaxica.com"
    }
    "umaxica-apps-edge-net-apex" = {
      service   = "umaxica-apps-edge-net-apex"
      hostname  = "umaxica.net"
      zone_name = "umaxica.net"
    }
    "umaxica-apps-edge-org-apex" = {
      service   = "umaxica-apps-edge-org-apex"
      hostname  = "umaxica.org"
      zone_name = "umaxica.org"
    }
    "umaxica-apps-edge-org-core" = {
      service   = "umaxica-apps-edge-org-core"
      hostname  = "jp.umaxica.org"
      zone_name = "umaxica.org"
    }
    "umaxica-apps-edge-org-core-us" = {
      service   = "umaxica-apps-edge-org-core"
      hostname  = "us.umaxica.org"
      zone_name = "umaxica.org"
    }
    "umaxica-apps-edge-org-docs-jp" = {
      service   = "umaxica-apps-edge-org-docs"
      hostname  = "docs-jp.umaxica.org"
      zone_name = "umaxica.org"
    }
    "umaxica-apps-edge-org-help-jp" = {
      service   = "umaxica-apps-edge-org-help"
      hostname  = "help-jp.umaxica.org"
      zone_name = "umaxica.org"
    }
    "umaxica-apps-edge-org-news-jp" = {
      service   = "umaxica-apps-edge-org-news"
      hostname  = "news-jp.umaxica.org"
      zone_name = "umaxica.org"
    }
  }

}

# =============================================================================
# Worker Domains
# =============================================================================

resource "cloudflare_workers_custom_domain" "workers" {
  for_each = local.worker_custom_domains

  account_id = var.account_id
  hostname   = each.value.hostname
  service    = each.value.service
  zone_id    = local.zones[each.value.zone_name]

  lifecycle {
    ignore_changes = [environment]
  }
}
