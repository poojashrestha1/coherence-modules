output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(aws_s3_bucket.this[0].arn, "")
}

output "bucket_name" {
  description = "Name of bucket created"
  value       = try(aws_s3_bucket.this[0].bucket, "")
}
