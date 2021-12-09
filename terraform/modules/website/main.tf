terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  cloudfront_origin_id = "s3"
  mime_types = {
    css   = "text/css"
    html = "text/html"
    jpeg = "image/jpeg"
    jpg = "image/jpeg"
    js = "text/javascript"
    png = "image/png"
    ttf = "font/ttf"
    woff = "font/woff"
    woff2 = "font/woff2"
    xml = "text/xml"
  }
  upload_directory = "${path.root}/../../../output/"
  index_page = "index.html"
}

resource "aws_cloudfront_origin_access_identity" "identity" {}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "website_files" {
  for_each      = fileset(local.upload_directory, "**/*.*")
  bucket        = aws_s3_bucket.bucket.bucket
  key           = replace(each.value, local.upload_directory, "")
  source        = "${local.upload_directory}${each.value}"
  etag          = filemd5("${local.upload_directory}${each.value}")
  content_type  = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
  cache_control = "max-age=172800"
}

data "aws_iam_policy_document" "document" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.document.json
}

data "aws_acm_certificate" "certificate" {
  domain = element(var.domain_names, 0)
  types = ["AMAZON_ISSUED"]
}

resource "aws_cloudfront_cache_policy" "cache_policy" {
  name = "caching-optimized"
  min_ttl = 1
  max_ttl = 315360000
  default_ttl = 86400

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }

    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip = true
  }
}

resource "aws_cloudfront_response_headers_policy" "headers_policy" {
  name = "security-headers-policy"

  custom_headers_config {
    items {
      header = "permissions-policy"
      override = true
      value = "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()"
    }
  }

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      override = true
      frame_option = "DENY"
    }

    referrer_policy {
      override = true
      referrer_policy = "same-origin"
    }

    strict_transport_security {
      override = true
      access_control_max_age_sec = 63072000
      include_subdomains = true
      preload = true
    }

    xss_protection {
      override = true
      mode_block = true
      protection = true
    }
  }
}

resource "aws_cloudfront_distribution" "distribution" {
  aliases = var.domain_names
  enabled = true
  default_root_object = local.index_page

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_domain_name
    origin_id = local.cloudfront_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.identity.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    compress = true
    target_origin_id = local.cloudfront_origin_id
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id = aws_cloudfront_cache_policy.cache_policy.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.headers_policy.id
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.certificate.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  dynamic "custom_error_response" {
    for_each = [400, 403, 404, 405, 414]
    content {
      error_code = custom_error_response.value
      response_code = 404
      response_page_path = var.error_page_path
      error_caching_min_ttl = 300
    }
  }
}
