terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.tags
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "networking" {
  source             = "./modules/networking"
  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = var.tags
}

module "storage" {
  source               = "./modules/storage"
  name_prefix          = local.name_prefix
  frontend_bucket_name = var.frontend_bucket_name
  tags                 = var.tags
}

module "monitoring" {
  source      = "./modules/monitoring"
  name_prefix = local.name_prefix
  tags        = var.tags
}

module "compute" {
  source                = "./modules/compute"
  name_prefix           = local.name_prefix
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  private_subnet_ids    = module.networking.private_subnet_ids
  instance_type         = var.backend_instance_type
  min_size              = var.backend_min_size
  max_size              = var.backend_max_size
  desired_capacity      = var.backend_desired_capacity
  redis_node_type       = var.redis_node_type
  backend_image         = var.backend_image
  mongo_uri             = var.mongo_uri
  instance_profile_name = module.monitoring.instance_profile_name
  cloudwatch_log_group  = module.monitoring.app_log_group_name
  tags                  = var.tags
}
