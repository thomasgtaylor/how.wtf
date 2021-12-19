terraform {
  backend "s3" {
    bucket = "terraform.how.wtf"
    key = "env/global/terraform.tfstate"
    region = "us-east-1"
  }
}

provider aws {
  region = "us-east-1"
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
