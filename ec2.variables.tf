variable "key_pair" {
  type        = string
  description = "EC2 key_pair"
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "instance_names" {
  type = map(string)
}

variable "userdata_filenames" {
  type = map(string)

}
