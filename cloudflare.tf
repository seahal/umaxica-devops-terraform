

resource "cloudflare_turnstile_widget" "example" {
  account_id = var.cloudflare_tunsile_api_token
  name = ""
  domains = ["example.com"]
  mode = "managed"
}