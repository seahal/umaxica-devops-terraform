terraform {
  backend "s3" {
    bucket       = "umaxica.production.terraform.backend"
    region       = "ap-northeast-1"
    profile      = "hoge-terraformer"
    key          = "production.tfstate"
    encrypt      = true
    use_lockfile = true # 本設定にてS3のみでロックが可能
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "umaxica.production.terraform.backend"
}