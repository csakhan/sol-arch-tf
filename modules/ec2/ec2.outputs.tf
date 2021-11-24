output "ec2_IDs" {
  description = "ec2-IDs"
  value       = [for inst in aws_instance.web_instances : inst.id]
}

output "public_IPs" {
  description = "sg-ID"
  value       = [for inst in aws_instance.web_instances : inst.public_ip]
}
