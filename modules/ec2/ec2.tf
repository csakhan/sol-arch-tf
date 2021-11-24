resource "aws_instance" "web_instances" {

  count                  = var.ec2count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name
  user_data              = var.userdata_filename != "" ? file(var.userdata_filename) : ""
  tags                   = merge(var.tags, { Name = "${var.name}-${count.index}" })
}

