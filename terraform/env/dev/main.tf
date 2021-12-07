terraform {
  backend "s3" {
    bucket = "terraform.how.wtf"
    key = "env/dev/terraform.tfstate"
    region = "us-east-1"
  }
}

provider aws {
  region = "us-east-1"
}

module "website" {
  source = "../../modules/website"
  acm_certificate_id = "4f0374bd-8cc8-49ca-a475-c9b794a9d831"
  bucket_name = "dev.how.wtf"
  domain_names = ["dev.how.wtf"]
  security_header_function_name = "security-headers-dev"
}

output "cloudfront_distribution_id" {
  value = module.website.cloudfront_distribution_id
}
