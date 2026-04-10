locals {
  dns_records = {
    "umaxica-com-dmarc" = {
      content   = "v=DMARC1;p=quarantine;rua=mailto:9860051943d349cb9ac89d814ccb62de@dmarc-reports.cloudflare.net,mailto:my_dmarc_report@umaxica.com"
      name      = "_dmarc.umaxica.com"
      proxied   = false
      ttl       = 1
      type      = "TXT"
      zone_name = "umaxica.com"
    }
    "umaxica-com-dkim-225cmpojlggjuafl2xhm72q6o2zvk4k2" = {
      content   = "225cmpojlggjuafl2xhm72q6o2zvk4k2.dkim.amazonses.com"
      name      = "225cmpojlggjuafl2xhm72q6o2zvk4k2._domainkey.umaxica.com"
      proxied   = false
      ttl       = 1
      type      = "CNAME"
      zone_name = "umaxica.com"
    }
    "umaxica-com-dkim-exsevks4wdhs5pdfdrcyhmkcnteosbte" = {
      content   = "exsevks4wdhs5pdfdrcyhmkcnteosbte.dkim.amazonses.com"
      name      = "exsevks4wdhs5pdfdrcyhmkcnteosbte._domainkey.umaxica.com"
      proxied   = false
      ttl       = 1
      type      = "CNAME"
      zone_name = "umaxica.com"
    }
    "umaxica-com-dkim-vkubpj5yhizoo4ywqs6rajavdaax3wxf" = {
      content   = "vkubpj5yhizoo4ywqs6rajavdaax3wxf.dkim.amazonses.com"
      name      = "vkubpj5yhizoo4ywqs6rajavdaax3wxf._domainkey.umaxica.com"
      proxied   = false
      ttl       = 1
      type      = "CNAME"
      zone_name = "umaxica.com"
    }
    "umaxica-com-google-site-verification" = {
      content   = "google-site-verification=LDZbaCvwTKJhpp2R6gYBINe1PvCXI32HX--ukiCEWrU"
      name      = "umaxica.com"
      ttl       = 1
      type      = "TXT"
      zone_name = "umaxica.com"
    }
    "umaxica-com-help-jp" = {
      content   = "ghs.googlehosted.com"
      name      = "help.jp.umaxica.com"
      proxied   = false
      ttl       = 1
      type      = "CNAME"
      zone_name = "umaxica.com"
    }
    "umaxica-com-help-us" = {
      content   = "ghs.googlehosted.com"
      name      = "help.us.umaxica.com"
      proxied   = false
      ttl       = 1
      type      = "CNAME"
      zone_name = "umaxica.com"
    }
    "umaxica-com-spf" = {
      content   = "v=spf1 -all"
      name      = "umaxica.com"
      ttl       = 1
      type      = "TXT"
      zone_name = "umaxica.com"
    }
    "umaxica-org-dkim-zkuw6fb6qfkilfweh7hea5pzm4pjdg5j" = {
      content   = "zkuw6fb6qfkilfweh7hea5pzm4pjdg5j.dkim.amazonses.com"
      name      = "zkuw6fb6qfkilfweh7hea5pzm4pjdg5j._domainkey.umaxica.org"
      proxied   = false
      ttl       = 1
      type      = "CNAME"
      zone_name = "umaxica.org"
    }
  }

  dns_record_existing = merge([
    for zone_name, zone_records in {
      for key, ds in data.cloudflare_dns_records.records : key => ds.result
      } : {
      for record in zone_records :
      "${zone_name}|${record.name}|${record.type}|${coalesce(try(record.content, null), "")}" => record
    }
  ]...)

  dns_record_imports = {
    for key, config in local.dns_records :
    key => local.dns_record_existing[
      "${config.zone_name}|${config.name}|${config.type}|${coalesce(try(config.content, null), "")}"
    ]
    if contains(
      keys(local.dns_record_existing),
      "${config.zone_name}|${config.name}|${config.type}|${coalesce(try(config.content, null), "")}"
    )
  }
}

# =============================================================================
# DNS Records
# =============================================================================

data "cloudflare_dns_records" "records" {
  for_each = {
    "umaxica.com" = local.zones["umaxica.com"]
    "umaxica.org" = local.zones["umaxica.org"]
  }

  zone_id = each.value
}

resource "cloudflare_dns_record" "records" {
  for_each = local.dns_records

  zone_id = local.zones[each.value.zone_name]
  name    = each.value.name
  type    = each.value.type
  content = each.value.content
  proxied = try(each.value.proxied, null)
  ttl     = each.value.ttl
}

import {
  for_each = local.dns_record_imports
  to       = cloudflare_dns_record.records[each.key]
  id       = "${local.zones[each.value.zone_name]}/${each.value.id}"
}
