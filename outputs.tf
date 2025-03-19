output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}

output "example" {
  description = "value"
  value       = aws_s3_bucket.access_log.tags.Environment
}