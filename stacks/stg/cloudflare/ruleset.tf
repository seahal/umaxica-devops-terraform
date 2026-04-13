locals {
  zone_ruleset_ids = {
    "umaxica.app" = "6714e5825a904adfbf126ecc4a0a9005"
    "umaxica.com" = "9c75f83d540b4dc7be115ee9aa34225c"
    "umaxica.net" = "f76661bcf6194053ad075c8639a05f99"
    "umaxica.org" = "5a043906b64d46878e08737a8992955e"
  }
}

# =============================================================================
# Zone Rulesets
# =============================================================================

import {
  for_each = local.zone_ruleset_ids
  to       = cloudflare_ruleset.zone_ruleset[each.key]
  id       = "zones/${local.zones[each.key]}/${each.value}"
}

resource "cloudflare_ruleset" "zone_ruleset" {
  for_each = local.zones

  zone_id     = each.value
  name        = "default"
  description = ""
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules = []

  lifecycle {
    # rules are managed incrementally; prevent accidental deletion of existing rules
    ignore_changes = [name, rules]
  }
}
