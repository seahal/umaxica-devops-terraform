terraform {
  backend "s3" {
    bucket       = "tfstate-203276832454-ap-northeast-1-an"
    key          = "live/prod/gcp/asia-northeast1/identity/terraform.tfstate"
    region       = "ap-northeast-1"
    profile      = "tofu"
    use_lockfile = true
  }
}
