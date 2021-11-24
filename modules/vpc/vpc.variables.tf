variable "cidr_block" {
  type        = string
  description = "CIDR Block"
}

variable "tags" {
  type        = map(string)
  description = "VPC tags"
}

variable "enable_dns_support" {
  type        = bool
  description = "DNS Support"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Hostname Support"
}

# variable "public_subnet_cidr_blocks" {
#   type        = map(object({ subnet_az = string, subnet_type = string, tier_type = string, ngway = bool }))
#   description = "Subnet CIDR blocks"
# }

# variable "private_subnet_cidr_blocks" {
#   type        = map(object({ subnet_az = string, subnet_type = string, tier_type = string }))
#   description = "Subnet CIDR blocks"
# }

variable "availability_zones" {
  type        = list(string)
  description = "Availibility zones"
}

variable "public_subnet_cidr_blocks" {
  type        = set(object({ cidr = string, subnet_az = string, subnet_type = string, tier_type = string }))
  description = "Subnet CIDR blocks"
}

variable "private_app_cidr_blocks" {
  type        = set(object({ cidr = string, subnet_az = string, subnet_type = string, tier_type = string }))
  description = "App Subnet CIDR blocks"
}
variable "private_db_cidr_blocks" {
  type        = set(object({ cidr = string, subnet_az = string, subnet_type = string, tier_type = string }))
  description = "DB Subnet CIDR blocks"
}

variable "multi_az_natgway" {
  type        = bool
  description = "Enable Multi AZ Nat Gateway for Private Subnets"
}
