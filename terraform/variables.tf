variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "strapi-app"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "docker_username" {
  description = "Docker Hub Username"
  type        = string
  sensitive   = true
}

variable "docker_password" {
  description = "Docker Hub Password/Token"
  type        = string
  sensitive   = true
}

variable "strapi_image" {
  description = "Docker Image Name (e.g., myuser/my-strapi-app)"
  type        = string
}

variable "strapi_image_tag" {
  description = "Docker Image Tag"
  type        = string
  default     = "latest"
}
