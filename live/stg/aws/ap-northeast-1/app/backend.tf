terraform {
  backend "s3" {
    bucket       = "tfstate-203276832454-ap-northeast-1-an"
    key          = "live/stg/aws/ap-northeast-1/app/terraform.tfstate"
    region       = "ap-northeast-1"
    profile      = "tofu"
    use_lockfile = true
  }
}
