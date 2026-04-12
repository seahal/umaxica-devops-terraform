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
      head_sampling_rate = 0.2
      invocation_logs    = true
      persist            = true
    }
    traces = {
      enabled            = true
      head_sampling_rate = 0.2
    }
  }

  subdomain = {
    enabled          = false
    previews_enabled = true
  }

  tags = [
    "cf:environment=production",
    "cf:service=${each.key}",
  ]

  lifecycle {
    prevent_destroy = true
  }
}
