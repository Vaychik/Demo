resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  acl    = var.acl

  versioning {
    enabled = true
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 7
    enabled                                = true
    id                                     = "CloudControl-S3: S3 Buckets Permissions Purifier"
  }

  tags = var.tags

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}