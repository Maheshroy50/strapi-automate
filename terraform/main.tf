
module "ec2" {
  source        = "./modules/ec2"
  project_name  = var.project_name
  instance_type = var.instance_type
  region        = var.region
  key_name      = "strapi"

  docker_username = var.docker_username
  docker_password = var.docker_password

  docker_compose_content = templatefile("${path.module}/templates/docker-compose.yml.tpl", {
    strapi_image = "${var.strapi_image}:${var.strapi_image_tag}"
  })

  nginx_conf_content = file("${path.module}/../nginx.conf")
}
