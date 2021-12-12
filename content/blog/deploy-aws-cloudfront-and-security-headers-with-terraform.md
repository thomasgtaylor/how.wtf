Title: Deploy AWS Cloudfront and Security Headers with Terraform
Date: 2021-12-12 2:15
Category: Cloud
Tags: AWS, Terraform, Python, Serverless
Authors: Thomas Taylor
Description: How to deploy AWS Cloudfront using Terraform to add security headers to responses.

I made a post in July 2021 regarding [AWS CloudFront + security headers][1]. Using AWS Cloudfront and Cloudfront Functions, security headers were injected in viewer responses; however, AWS Cloudfront [natively supports security headers as of Nov. 2nd, 2021][2] alongside configurable CORS and custom HTTP response headers

# Security Headers

Cloudfront can natively support all the security headers from the last post:

- permissions-policy
- referrer-policy
- strict-transport-security
- x-content-type-options
- x-frame-options
- x-xss-protection

# Terraform Code

Begin with defining an `aws_cloudfront_response_headers_policy` resource in Terraform. This resources contains all the header policy information. In the following example, the values for each `security_headers_config` were copied from [AWS's documentation][3].

```hcl
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
```

Attach it to a Cloudfront Behavior. In this case, I attached it to the `default_cache_behavior` block.

```hcl
locals {
  cloudfront_origin_id = "s3"
}

resource "aws_cloudfront_distribution" "distribution" {
  aliases = var.domain_names
  enabled = true

  origin {
    domain_name = aws_s3_bucket.bucket.bucket_domain_name
    origin_id = local.cloudfront_origin_id
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    compress = true
    target_origin_id = local.cloudfront_origin_id
    viewer_protocol_policy = "redirect-to-https"
    response_headers_policy_id = aws_cloudfront_response_headers_policy.headers_policy.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
```

Once your infrastructure is deployed, AWS CloudFront will forward security headers. To see this in action, refer to the [`how.wtf`][4] repository.

[1]: https://how.wtf/deploy-cloudfront-functions-to-add-security-headers-with-aws-cdk.html
[2]: https://aws.amazon.com/about-aws/whats-new/2021/11/amazon-cloudfront-supports-cors-security-custom-http-response-headers
[3]: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/example-function-add-security-headers.html
[4]: https://github.com/thomasnotfound/how.wtf/blob/130df83b8bdccee26557be4a73908c30651a9a5e/terraform/modules/website/main.tf
