output "public_ip" {
  value = aws_instance.strapi_server.public_ip
}

output "instance_id" {
  value = aws_instance.strapi_server.id
}

output "private_key_pem" {
  value     = tls_private_key.generated.private_key_pem
  sensitive = true
}
