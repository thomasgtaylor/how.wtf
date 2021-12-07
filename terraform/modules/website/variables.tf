variable "acm_certificate_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "domain_names" {
  type = list(string)
}

variable "security_header_function_name" {
  type = string
  default = "security-headers"
}

variable "error_page_path" {
  type = string
  default = "/error.html"
}
