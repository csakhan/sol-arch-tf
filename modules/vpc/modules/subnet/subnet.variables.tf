variable "subnet_cidr_blocks" {
  type        = set(object({ cidr = string, subnet_az = string, subnet_type = string, tier_type = string }))
  description = "Subnet CIDR blocks"
}

variable "tags" {
  type        = map(string)
  description = "VPC tags"
}

variable "vpc_id" {
  type        = string
  description = "VPC tags"
}