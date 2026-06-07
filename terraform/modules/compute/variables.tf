variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "instance_type" { type = string }
variable "min_size" { type = number }
variable "max_size" { type = number }
variable "desired_capacity" { type = number }
variable "redis_node_type" { type = string }
variable "backend_image" { type = string }
variable "instance_profile_name" { type = string }
variable "cloudwatch_log_group" { type = string }
variable "tags" { type = map(string) }

variable "mongo_uri" {
  type      = string
  sensitive = true
}
