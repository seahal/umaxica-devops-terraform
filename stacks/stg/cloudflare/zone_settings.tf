# =============================================================================
# Zone Settings
#
# Always Use HTTPS: HTTP リクエストを HTTPS に 301 リダイレクトする
# https://developers.cloudflare.com/ssl/edge-certificates/additional-options/always-use-https/
# =============================================================================

resource "cloudflare_zone_setting" "always_use_https" {
  for_each = local.zones

  zone_id    = each.value
  setting_id = "always_use_https"
  value      = "on"
}

import {
  for_each = local.zones
  to       = cloudflare_zone_setting.always_use_https[each.key]
  id       = "${each.value}/always_use_https"
}
