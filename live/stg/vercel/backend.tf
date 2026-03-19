terraform {
  backend "s3" {
    bucket       = "tfstate-837095527456-ap-northeast-1"
    key          = "live/stg/vercel/terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}
