terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

variable "image_name" {
  description = "Image to run"
  type        = string
  default     = "nileshkatalkar/jenkins-flask-app:latest"
}

variable "container_name" {
  type    = string
  default = "tf-flask"
}

variable "external_port" {
  description = "Port on your PC"
  type        = number
  default     = 8095
}

resource "docker_image" "app" {
  name         = var.image_name
  keep_locally = true
}

resource "docker_container" "app" {
  name    = var.container_name
  image   = docker_image.app.image_id
  restart = "unless-stopped"

  ports {
    internal = 5000
    external = var.external_port
  }
}

output "url" {
  value = "http://localhost:${var.external_port}"
}

output "container_name" {
  value = docker_container.app.name
}