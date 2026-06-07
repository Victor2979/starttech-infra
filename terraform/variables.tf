variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "project_name" {
  type    = string
  default = "starttech"
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "backend_instance_type" {
  type    = string
  default = "t3.micro"
}
variable "backend_min_size" {
  type    = number
  default = 1
}
variable "backend_max_size" {
  type    = number
  default = 3
}
variable "backend_desired_capacity" {
  type    = number
  default = 2
}
variable "redis_node_type" {
  type    = string
  default = "cache.t3.micro"
}
variable "frontend_bucket_name" {
  type    = string
  default = ""
}
variable "backend_image" {
  type    = string
  default = "muchtodo-backend:latest"
}
variable "mongo_uri" {
  type      = string
  default   = ""
  sensitive = true
}
variable "tags" {
  type = map(string)
  default = {
    Project   = "starttech"
    ManagedBy = "terraform"
  }
}
