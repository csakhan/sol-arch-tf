output "vpc_ID" {
  description = "VPC ID"
  value       = aws_vpc.web_vpc.id
}

output "public_subnets" {
  value = local.all_public_subnets
}


# output "subnet_ids" {
#   value = [for subnet in aws_subnet.public_subnets : subnet][0].availability_zone #{ for id, values in aws_subnet.public_subnets : id => values }
# }

# # output "ngwaysnets" {
# #   value = { for key, values in var.public_subnet_cidr_blocks : key => values if values.ngway == true }
# # }


# output "zz" {
#   #value = zipmap([for subnet in aws_subnet.public_subnets : subnet.id], values({ for cidr, values in var.public_subnet_cidr_blocks : cidr => values.ngway }))
#   value = values({ for cidr, values in var.public_subnet_cidr_blocks : cidr => values.ngway })
# }
