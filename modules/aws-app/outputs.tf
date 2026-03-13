output "bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "The ID of the S3 bucket."
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "The ARN of the S3 bucket."
}

output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.this.website_endpoint
  description = "The website endpoint of the S3 bucket."
}
