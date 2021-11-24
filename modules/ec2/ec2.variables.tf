variable "ami" {
  type        = string
  description = "AMI Name"
}

variable "instance_type" {
  type        = string
  description = "AInstance type"
}

variable "tags" {
  type        = map(string)
  description = "VPC tags"
}

variable "userdata_filename" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "sg_id" {
  type = string
}

variable "ec2count" {
  type = number
}
