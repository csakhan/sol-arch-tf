resource "null_resource" "web" {
  depends_on = [
    module.bastion
  ]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = ""
    private_key = file("terraform-key.pem")
    host        = module.bastion.public_IPs[0]
  }
  provisioner "file" {
    source      = "terraform-key.pem"
    destination = "/tmp/terraform-key.pem"
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod 400 /tmp/terraform-key.pem"]
  }

  provisioner "local-exec" {
    command     = "echo VPC created on `date` with VPC ID: ${module.vpc.vpc_ID} >> creation-time-vpc-id.txt"
    working_dir = "outputs/"
  }
}
