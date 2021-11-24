locals {
  owners      = "${var.business}-${var.department}"
  environment = var.environment

  common_tags = {
    Owners      = local.owners
    Environment = local.environment
  }
  project_availability_zones = data.aws_availability_zones.web_azs.names
  #all_zones_subnets          = flatten([local.project_availability_zones, local.project_availability_zones, local.project_availability_zones])
}

