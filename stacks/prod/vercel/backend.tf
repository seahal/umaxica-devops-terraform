terraform {
  backend "s3" {
    bucket       = "tfstate-203276832454-ap-northeast-1-an"
    key          = "stacks/prod/vercel/terraform.tfstate"
    region       = "ap-northeast-1"
    profile      = "tofu"
    use_lockfile = true
  }
}
