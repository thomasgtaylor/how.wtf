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
  bucket_name = "dev.how.wtf"
  domain_names = ["dev.how.wtf"]
}

output "cloudfront_distribution_id" {
  value = module.website.cloudfront_distribution_id
}
