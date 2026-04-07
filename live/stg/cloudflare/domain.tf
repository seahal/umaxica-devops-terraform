locals {
  zones = {
    "umaxica.app" = "689f76e1f7509c1aa8f223425b5d6a39"
    "umaxica.com" = "5d6e1d349e3c48b25feca13b497f9c99"
    "umaxica.net" = "d1c2e765f7b5c9b343f7e03a31d91ecf"
    "umaxica.org" = "771b6a675b8758959117a2874e828d21"
  }
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
