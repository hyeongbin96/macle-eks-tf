output "state_bucket_name" {
  description = "Terraform state S3 버킷 이름 (envs/*/backend.tf의 bucket 값)"
  value       = aws_s3_bucket.tfstate.bucket
}

output "state_bucket_arn" {
  description = "Terraform state S3 버킷 ARN"
  value       = aws_s3_bucket.tfstate.arn
}
