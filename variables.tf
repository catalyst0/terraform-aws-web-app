# Main
variable "profile" {
  description = "Name of the local AWS profile"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "admin_ip" {
  description = "IP or IP range for the admin clients"
  type        = string
}

variable "s3_bucket_source" {
  description = "S3 bucket name - source of code"
  type        = string
}

variable "network" {
  description = "CIDR for VPC, CIDRs for 2 public and 2 private subnets"
}

variable "inst_params" {
  description = "AMIs to use. Make sure to align with a region"
}

variable "tags" {
  description = "Dictionary of tags"
  type        = map(string)
}

variable "asg_params" {
  description = "AutoScaling group parameters"
  type        = map(string)
}

variable "iam_policies_arn_jenkins" {
  description = "IAM Policies to be attached to instance role"
  type        = list
}