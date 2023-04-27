locals {
  context = {
    env = "dev"
    region = "us-west-2"
    team = "test-team"
    service = "test-srv"
    component = "redis"
  }
}

provider "aws" {
  region = "us-west-2"
}

module "redis" {
  source = "a3linux/redis/aws"

  context = local.context
  vpc_name = "test-vpc"
  subnet_name = "test-*"
  name = "test"
}

output "redis_endpoint" {
  value = module.redis.redis_endpoint
  description = "Redis Endpoint"
}
