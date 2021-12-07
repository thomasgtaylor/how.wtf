terraform {
  backend "s3" {
    bucket = "terraform.how.wtf"
    key = "env/prod/terraform.tfstate"
    region = "us-east-1"
  }
}

provider aws {
  region = "us-east-1"
}

module "website" {
  source = "../../modules/website"
  acm_certificate_id = "a3a16b29-cfb7-4524-a97e-70f8fc2103d5 "
  bucket_name = "how.wtf"
  domain_names = ["www.how.wtf", "how.wtf"]
  security_header_function_name = "security-headers-dev"
}

output "cloudfront_distribution_id" {
  value = module.website.cloudfront_distribution_id
}
