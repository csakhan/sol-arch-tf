variable "name" {
  type        = string
  description = "SG Name"
}

variable "description" {
  type        = string
  description = "SG Description"
}
variable "vpc_id" {
  type        = string
  description = "SG VPC Id"
}

variable "rules" {
  type =  list(object({ port = number, description=string, protocol=string,cidr_blocks=list(string)})) 
}

variable "tags" {
  type        = map(string)
  description = "VPC tags"
}