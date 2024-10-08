output "s3-bucket-name" {
  value = aws_s3_bucket.tform-ak-backend.bucket
}

output "dynamodbtable" {
  value = aws_dynamodb_table.terraform-state-lock.name
}