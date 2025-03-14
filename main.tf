

resource "aws_s3_bucket" "example" {
  bucket = "umaxica.app"
}

resource "aws_s3_bucket" "cloudfront_functions" {
  bucket = "umaxica.cloudfront.functions"

  tags = {
    Name        = "snipets for cloudfront functions"
    Environment = "Production"
  }
}

# module "key_pair" {
#   source  = "terraform-aws-modules/key-pair/aws"
#   version = "~> 2.0"

#   key_name_prefix    = var.name_prefix
#   create_private_key = true

#   tags = local.tags
# }