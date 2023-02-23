# S3 bucket for website.
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"
  acl    = "public-read"
  policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = var.common_tags
}

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })

  website {
    redirect_all_requests_to = "https://www.${var.domain_name}"
  }

  tags = var.common_tags
}

locals {
  mime_types = {
    css = "text/css"
    html = "text/html"
    js = "application/javascript"
    json = "application/json"
    txt = "text/plain"
    png = "image/png"
    jpeg = "image/jpeg"
    jpg = "image/jpg"
  }
}

resource "aws_s3_object" "file" {
  for_each = fileset(var.website_root, "**")

  bucket = aws_s3_bucket.www_bucket.id
  key    = each.key
  source = "${var.website_root}/${each.key}"
  etag   = filemd5("${var.website_root}/${each.key}")
  acl    = "public-read"
  content_type = lookup(local.mime_types, element(split(".", each.value), length(split(".", each.value)) - 1), "text/plain")

}