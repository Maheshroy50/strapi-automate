

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ssh_command" {
  value = "ssh -i ${var.project_name}-key.pem ubuntu@${module.ec2.public_ip}"
}
