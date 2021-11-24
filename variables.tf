variable "environment" {
  type        = string
  description = "Env in which App running"
  default     = "Test"
}

variable "business" {
  type        = string
  description = "Business for which App running"
  default     = "Financial"
}

variable "department" {
  type        = string
  description = "Department for which App running"
  default     = "Trading"
}

variable "region" {
  type        = string
  description = "Region in which App running"
}
