variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}



variable "docker_compose_content" {
  description = "Content of docker-compose.yml"
  type        = string
}

variable "nginx_conf_content" {
  description = "Content of nginx.conf"
  type        = string
}

variable "docker_username" {
  description = "Docker Hub Username"
  type        = string
  sensitive   = true
}

variable "docker_password" {
  description = "Docker Hub Password"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS Region"
  type        = string
}
