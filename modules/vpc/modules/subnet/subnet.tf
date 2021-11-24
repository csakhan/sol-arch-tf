resource "aws_subnet" "subnets" {

  for_each                = { for subnet in var.subnet_cidr_blocks : subnet.cidr => subnet }
  vpc_id                  = var.vpc_id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["subnet_az"]
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${each.value["subnet_type"]}Subnet-${each.value["subnet_az"]}-${each.value["tier_type"]}",
    #NatGway = each.value["ngway"]
  })
}
