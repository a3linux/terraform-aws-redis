locals {
  name                          = var.name == null ? module.context.label : var.name
  description                   = length(var.description) > 0 ? var.description : module.context.label

  vpc_id                        = var.vpc_id == null ? module.vpc[0].vpc_id : var.vpc_id
  subnet_ids                    = length(var.subnet_ids) == 0 ? module.subnets[0].subnet_ids : var.subnet_ids
  availability_zones = length(var.availability_zones) > 0 ? var.availability_zones : module.subnets.subnet_azs
  elasticache_subnet_group_name = var.elasticache_subnet_group_name != "" ? var.elasticache_subnet_group_name : join("", aws_elasticache_subnet_group.default[0].name)

  # if !cluster, then node_count = replica cluster_size, if cluster then node_count = shard*(replica + 1)
  # Why doing this 'The "count" value depends on resource attributes that cannot be determined until apply'. So pre-calculating
  member_clusters_count = (var.cluster_mode_enabled ? (var.cluster_mode_num_node_groups * (var.cluster_mode_replicas_per_node_group + 1)) : var.cluster_size)
  elasticache_member_clusters = length(local.name) > 0 ? tolist(aws_elasticache_replication_group.default[0].member_clusters) : []

  redis_endpoint  = var.cluster_mode_enabled ? aws_elasticache_replication_group.default.*.configuration_endpoint_address : aws_elasticache_replication_group.default.*.primary_endpoint_address
  redis_fqdn      = var.create_dns_cname ? aws_route53_record.dns_cname.fqdn : ""
}

module "vpc" {
  count = var.vpc_id == null ? 1 : 0

  source   = "a3linux/tagged-vpc/aws"
  vpc_name = var.vpc_name
}

module "subnets" {
  count = length(var.subnet_ids) == 0 ? 1 : 0

  source = "a3linux/tagged-subnets/aws"
  vpc_id = local.vpc_id
  name   = var.subnet_name
}

module "security_group" {
  source = "a3linux/security-group/aws"

  vpc_id                = local.vpc_id
  name                  = local.name
  context_values        = var.context
  allowed_sources       = var.allowed_sources
  allowed_ips           = var.allowed_ips
  allowed_services      = [var.port_service]
  port_service_mappings = var.port_service_mappings
}

resource "aws_elasticache_subnet_group" "default" {
  count = var.elasticache_subnet_group_name == "" ? 1 : 0

  name       = local.name
  subnet_ids = module.subnets.subnet_ids
}

resource "aws_elasticache_parameter_group" "default" {
  name   = local.name
  family = var.family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

data "aws_ssm_parameter" "auth_token" {
  count           = var.transit_encryption_enabled ? 1 : 0
  name            = var.auth_token_param_name
  with_decryption = true
}

resource "aws_elasticache_replication_group" "default" {
  count = length(local.name) > 0 ? 1 : 0

  auth_token                    = var.transit_encryption_enabled ? data.aws_ssm_parameter.auth_token[0].value : null
  replication_group_id          = local.name
  replication_group_description = local.description
  node_type                     = var.instance_type
  number_cache_clusters         = var.cluster_mode_enabled ? null : var.cluster_size
  port                          = var.port
  parameter_group_name          = aws_elasticache_parameter_group.default.name
  availability_zones            = local.availability_zones
  automatic_failover_enabled    = var.automatic_failover_enabled
  multi_az_enabled              = var.multi_az_enabled
  subnet_group_name             = local.elasticache_subnet_group_name
  security_group_ids            = compact(concat([module.security_group.id], var.security_groups))
  maintenance_window            = var.maintenance_window
  notification_topic_arn        = var.notification_topic_arn
  engine_version                = var.engine_version
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  kms_key_id                    = var.at_rest_encryption_enabled ? var.kms_key_id : null
  transit_encryption_enabled    = var.transit_encryption_enabled
  snapshot_name                 = var.snapshot_name
  snapshot_arns                 = var.snapshot_arns
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  final_snapshot_identifier     = var.final_snapshot_identifier
  apply_immediately             = var.apply_immediately

  tags = module.context.tags

  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? ["true"] : []
    content {
      replicas_per_node_group = var.cluster_mode_replicas_per_node_group
      num_node_groups         = var.cluster_mode_num_node_groups
    }
  }
}

data "aws_route53_zone" "selected" {
  count = local.create_dns_cname

  zone_id = var.zone_id
  name    = var.zone_name
  private_zone = var.is_private_zone
}

resource "aws_route53_record" "dns_cname" {
  count    = var.create_dns_cname ? 1 : 0

  zone_id  = try(data.aws_route53_zone.selected[0].zone_id, "")
  name     = var.dns_name == "" ? local.name : var.dns_name
  type     = "CNAME"
  ttl      = 60
  records  = var.cluster_mode_enabled ? [join("", aws_elasticache_replication_group.default.*.configuration_endpoint_address)] : [join("", aws_elasticache_replication_group.default.*.primary_endpoint_address)]
}
