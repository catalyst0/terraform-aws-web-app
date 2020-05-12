variable "subnets_list" {
  description = "List of subnets: 2 public and 2 private"
}

variable "security_group" {
  description = "Dict of Security Groups"
}

variable "ami" {
  description = "AMIs to use. Make sure to align with a region"
  type        = map(string)
}

variable "instance_type" {
  description = "Instance types"
  type        = map(string)
}

variable "key_name" {
  description = "Key-pairs for the respective servers"
  type        = map(string)
}

variable "tags" {
  description = "Dictionary of tags"
  type        = map(string)
}