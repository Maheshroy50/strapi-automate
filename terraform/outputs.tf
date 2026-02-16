

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ssh_command" {
  value = "ssh -i strapi.pem ubuntu@${module.ec2.public_ip}"
}
