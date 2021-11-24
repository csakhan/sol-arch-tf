# output "az_list" {

#   value = flatten([data.aws_availability_zones.web_azs.names, data.aws_availability_zones.web_azs.names, data.aws_availability_zones.web_azs.names])
# }

# output "az_names" {

#   value = data.aws_availability_zones.web_azs.names
# }


# output "subnetids" {
#   value = module.vpc.subnet_ids
# }

# output "ngwaysnets" {
#   value = length(module.vpc.ngwaysnets)
# }

output "bastion-ec2_IDs" {
  value = module.bastion.ec2_IDs
}

output "bastion-Pub_IPs" {
  value = module.bastion.public_IPs
}

output "webservers-ec2_IDs" {
  value = module.webservers.ec2_IDs
}

output "webservers-Pub_IPs" {
  value = module.webservers.public_IPs
}
