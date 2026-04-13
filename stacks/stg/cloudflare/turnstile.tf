locals {
  turnstile_widgets = {
    "staging-stealth" = {
      domains = [
        "help-jp.umaxica.app",
        "help-jp.umaxica.com",
        "help.jp.umaxica.com",
        "jp.umaxica.app",
        "jp.umaxica.com",
        "jp.umaxica.org",
      ]
      mode = "invisible"
    }
    "staging-visible" = {
      domains = [
        "help-jp.umaxica.org",
        "help.us.umaxica.com",
        "jp.umaxica.org",
        "news-jp.umaxica.app",
        "news-jp.umaxica.com",
      ]
      mode = "managed"
    }
  }
}

# =============================================================================
# Turnstile Widgets
# =============================================================================

resource "cloudflare_turnstile_widget" "widgets" {
  for_each = local.turnstile_widgets

  account_id   = var.account_id
  domains      = each.value.domains
  name         = each.key
  mode         = each.value.mode
  ephemeral_id = false
  region       = "world"

  lifecycle {
    prevent_destroy = true
  }
}

import {
  to = cloudflare_turnstile_widget.widgets["staging-stealth"]
  id = "${var.account_id}/0x4AAAAAAB5rnugAuPf7hPUX"
}

import {
  to = cloudflare_turnstile_widget.widgets["staging-visible"]
  id = "${var.account_id}/0x4AAAAAACpq5e2vBH3XjFdd"
}
