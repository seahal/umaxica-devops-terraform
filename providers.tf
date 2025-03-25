

provider "aws" {
  region = var.region
  alias  = "primary"
}

provider "fastly" {
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}