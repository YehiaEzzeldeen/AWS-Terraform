data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "trail" {
  name                          = "${var.customer_name}-trail"
  s3_bucket_name                = aws_s3_bucket.bucket.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = true
  enable_log_file_validation = true
  is_multi_region_trail = true
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.customer_name}-trail-124879124798247"
  force_destroy = true
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "logsExpiry"
    enabled = true
    expiration {
      days = 90
    }
  }
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.customer_name}-trail-124879124798247"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.customer_name}-trail-124879124798247/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}