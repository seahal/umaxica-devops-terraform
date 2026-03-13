module "aws_app" {
  source = "../../../../../modules/aws-app"

  bucket_name = "staticpage.jp.staging.umaxica"
  environment = "staging"
}
