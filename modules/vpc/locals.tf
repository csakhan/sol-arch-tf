locals {
  #ngw_eip_subnets     = [for subnet in aws_subnet.public_subnets : subnet.id if subnet.tags.NatGway == "true"]
  nat_gway_count          = var.multi_az_natgway ? length(var.availability_zones) : 1
  all_public_subnets      = [for subnet in module.public_subnets.subnets : subnet]
  all_private_app_subnets = [for subnet in module.private_app_subnets.subnets : subnet]
  all_private_db_subnets  = [for subnet in module.private_db_subnets.subnets : subnet]
  all_private_subnets     = [local.all_private_app_subnets, local.all_private_db_subnets]
  #private_subnets_by_az   = { for subnet, az in local.all_private_subnets : subnet.id => subnet.availability_zone }
  #{ for az, subnets in var.availability_zones : az => [for subnet in aws_subnet.private_subnets : subnet.id if subnet.availability_zone == az] }



  #zz              = zipmap([for subnet in aws_subnet.public_subnets : subnet.id], values({ for cidr, values in var.public_subnet_cidr_blocks : cidr => values.ngway }))
}
