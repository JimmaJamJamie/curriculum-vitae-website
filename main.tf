# To print the bucket's website URL after creation
output "website_endpoint" {
  value = aws_s3_bucket.www_bucket.website_endpoint
}