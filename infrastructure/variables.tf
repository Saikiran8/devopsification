variable "project_id" {
  description = "value"
}
variable "project_region" {
  description = "value"
}
variable "gke_cluster" {
  description = "value"
}
variable "cluster_location" {
  description = "value"
}
variable "machine_type" {
  description = "value"
}
variable "k8s_version" {
  description = "value"
}
# variable "docker_username" {
#   description = "value"
# }
# variable "docker_password" {
#   description = "value"
# }
# variable "docker_email" {
#   description = "value"
# }
variable "docker_secret" {
  description = "value"
}
variable "dockerhub_username" {
  type        = string
  description = "Your Docker Hub username"
}

variable "dockerhub_password" {
  type        = string
  description = "Your Docker Hub password"
  sensitive   = true
}

variable "dockerhub_email" {
  type        = string
  description = "Your Docker Hub email"
}