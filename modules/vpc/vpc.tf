# main vpc
resource "aws_vpc" "web_vpc" {
  cidr_block           = var.cidr_block
  tags                 = var.tags
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}

# internet gateway
resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id
  tags   = var.tags
} 

module "public_subnets" {
  source = "./modules/subnet"
  subnet_cidr_blocks = var.public_subnet_cidr_blocks
  vpc_id            = aws_vpc.web_vpc.id
  tags = var.tags
}

module "private_app_subnets" {
  source = "./modules/subnet"
  subnet_cidr_blocks = var.private_app_cidr_blocks
  vpc_id            = aws_vpc.web_vpc.id
  tags = var.tags
}
module "private_db_subnets" {
  source = "./modules/subnet"
  subnet_cidr_blocks = var.private_db_cidr_blocks
  vpc_id            = aws_vpc.web_vpc.id
  tags = var.tags
}
 
resource "aws_eip" "web_natgw_eips" {
  count      = local.nat_gway_count
  vpc        = true
  depends_on = [aws_internet_gateway.web_igw]
  tags = merge(var.tags, {
    Name = local.all_public_subnets[var.multi_az_natgway ? count.index : 0].availability_zone
  })
}

resource "aws_nat_gateway" "web_natgws" {
  count         = local.nat_gway_count #length(local.ngw_eip_subnets)
  allocation_id = aws_eip.web_natgw_eips[count.index].id
  subnet_id     = local.all_public_subnets[var.multi_az_natgway ? count.index : 0].id # local.all_public_subnets[count.index]
  tags = merge(var.tags, {
    Name = local.all_public_subnets[var.multi_az_natgway ? count.index : 0].availability_zone
  })
  depends_on = [module.public_subnets, aws_internet_gateway.web_igw, aws_eip.web_natgw_eips]
}

# public rt
resource "aws_route_table" "web_public_rt" {
  vpc_id = aws_vpc.web_vpc.id
  tags = merge(var.tags, {
    Name = "Public-${var.availability_zones[0]}"
  })
}

# public route
resource "aws_route" "web_public_route" {
  route_table_id         = aws_route_table.web_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_igw.id
}

# public rt association
resource "aws_route_table_association" "web_public_rta" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = local.all_public_subnets[count.index].id
  route_table_id = aws_route_table.web_public_rt.id
}

# private rt app
resource "aws_route_table" "web_private_rt_app" {
  count  = local.nat_gway_count
  vpc_id = aws_vpc.web_vpc.id
  tags = merge(var.tags, {
    Name = "App-${var.availability_zones[count.index]}"
  })
}

# private rt association app
resource "aws_route_table_association" "web_private_rta_app" {
  count          = length(var.private_app_cidr_blocks)
  subnet_id      = local.all_private_app_subnets[count.index].id
  route_table_id = element(aws_route_table.web_private_rt_app.*.id, local.nat_gway_count == 1 ? 0 : count.index)
}

# nat gways route for private app subnets
resource "aws_route" "web_private_route_app" {
  count                  = local.nat_gway_count
  route_table_id         = aws_route_table.web_private_rt_app[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.web_natgws.*.id, local.nat_gway_count == 1 ? 0 : count.index)
}

# private rt db
resource "aws_route_table" "web_private_rt_db" {
  count  = local.nat_gway_count
  vpc_id = aws_vpc.web_vpc.id
  tags = merge(var.tags, {
    Name = "DB-${var.availability_zones[count.index]}"
  })
}

# private rt association db
resource "aws_route_table_association" "web_private_rta_db" {
  count          = length(var.private_db_cidr_blocks)
  subnet_id      = local.all_private_db_subnets[count.index].id
  route_table_id = element(aws_route_table.web_private_rt_db.*.id, local.nat_gway_count == 1 ? 0 : count.index)
}

# nat gways route for private subnets db
resource "aws_route" "web_private_route_db" {
  count                  = local.nat_gway_count
  route_table_id         = aws_route_table.web_private_rt_db[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.web_natgws.*.id, local.nat_gway_count == 1 ? 0 : count.index)
}

