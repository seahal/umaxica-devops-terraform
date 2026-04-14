terraform {
  backend "s3" {
    bucket       = "tfstate-837095527456-ap-northeast-1"
    key          = "stacks/stg/fastly/terraform.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}
