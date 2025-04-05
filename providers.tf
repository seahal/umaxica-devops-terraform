

provider "aws" {
  region = var.region
  alias  = "primary"
}

provider "fastly" {
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# provider "azure"{ 
# }
provider "azurerm" {
  features {}
  # 以下の環境変数を使用:
  # - ARM_SUBSCRIPTION_ID
  # - ARM_TENANT_ID
  # - ARM_CLIENT_ID
  # - ARM_CLIENT_SECRET
}