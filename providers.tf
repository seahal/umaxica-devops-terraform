

provider "aws" {
  region = var.region
}

provider "fastly" {
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
