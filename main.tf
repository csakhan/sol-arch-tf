provider "aws" {
  region  = var.region
  profile = "default"
}

module "vpc" {
  source                    = "./modules/vpc"
  cidr_block                = var.cidr_block
  tags                      = merge(local.common_tags, { Name = "Web-VPC" })
  enable_dns_support        = var.enable_dns_support
  enable_dns_hostnames      = var.enable_dns_hostnames
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_app_cidr_blocks   = var.private_app_cidr_blocks
  private_db_cidr_blocks    = var.private_db_cidr_blocks
  availability_zones        = local.project_availability_zones
  multi_az_natgway          = var.multi_az_natgway
}

# sg Basiton
module "sg-Bastion" {
  source      = "./modules/sg"
  tags        = merge(local.common_tags, { Name = "Bastion" })
  name        = lookup(var.sg_names, "Bastion")
  description = lookup(var.sg_desc, "Bastion")
  vpc_id      = module.vpc.vpc_ID
  rules       = [{ port = 22, description = "ssh", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }]
}

# sg Public
module "sg-Public" {
  source      = "./modules/sg"
  tags        = merge(local.common_tags, { Name = "Public" })
  name        = lookup(var.sg_names, "Public")
  description = lookup(var.sg_desc, "Public")
  vpc_id      = module.vpc.vpc_ID
  rules       = [{ port = 22, description = "ssh", protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }, { port = 80, description = "http", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }, { port = 443, description = "http", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }]
}

# sg Private
module "sg-Private" {
  source      = "./modules/sg"
  tags        = merge(local.common_tags, { Name = "Private" })
  name        = lookup(var.sg_names, "Private")
  description = lookup(var.sg_desc, "Private")
  vpc_id      = module.vpc.vpc_ID
  rules       = [{ port = 22, description = "ssh", protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }, { port = 80, description = "http", protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }, { port = 443, description = "http", protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }]
}

module "bastion" {
  source            = "./modules/ec2"
  ec2count          = 1
  ami               = data.aws_ami.web_ec2_ami.id
  instance_type     = var.instance_type
  subnet_ids        = module.vpc.public_subnets[*].id
  sg_id             = module.sg-Bastion.sg_ID
  key_name          = var.key_pair
  name              = lookup(var.instance_names, "Bastion", "")
  userdata_filename = lookup(var.userdata_filenames, "Bastion", "")
  tags              = merge(local.common_tags, { Name = lookup(var.instance_names, "Bastion") })
}

module "webservers" {
  source = "./modules/ec2"
  depends_on = [
    module.vpc
  ]
  ec2count          = length(var.public_subnet_cidr_blocks)
  ami               = data.aws_ami.web_ec2_ami.id
  instance_type     = var.instance_type
  subnet_ids        = module.vpc.public_subnets[*].id
  sg_id             = module.sg-Public.sg_ID
  key_name          = var.key_pair
  name              = lookup(var.instance_names, "Public", "")
  userdata_filename = lookup(var.userdata_filenames, "Public", "")
  tags              = merge(local.common_tags, { Name = lookup(var.instance_names, "Public") })
}
