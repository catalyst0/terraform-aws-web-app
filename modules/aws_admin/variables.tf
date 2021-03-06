variable "subnets_list" {
  description = "List of subnets: 2 public and 2 private"
}

variable "security_group" {
  description = "Dict of Security Groups"
}

variable "inst_params" {
  description = "AMIs to use. Make sure to align with a region"
}

variable "tags" {
  description = "Dictionary of tags"
  type        = map(string)
}