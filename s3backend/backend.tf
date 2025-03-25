terraform {
  backend "s3" {
    bucket       = "umaxica.production.terraform.backend"
    key          = "terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true # 本設定にてS3のみでロックが可能
  }
}