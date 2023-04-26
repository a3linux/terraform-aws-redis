resource "aws_cloudwatch_metric_alarm" "redis_cpu" {
  count = var.cloudwatch_alarms_enabled ? local.member_clusters_count : 0
  alarm_name = format("%s-CPUUtilization", element(local.elasticache_member_clusters, count.index))
  alarm_description = "Redis Cluster CPUUtilization Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = var.alarm_cpu_threshold_percent

  dimensions = {
    CacheClusterId = element(local.elasticache_member_clusters, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    aws_elasticache_parameter_group.default
  ]
}

resource "aws_cloudwatch_metric_alarm" "redis_evictions" {
  count = var.cloudwatch_alarms_enabled ? local.member_clusters_count : 0
  alarm_name = format("%s-Evictions", element(local.elasticache_member_clusters, count.index))
  alarm_description = "Redis Cluster Evictions Count Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "Evictions"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = var.alarm_evictions_threshold_count

  dimensions = {
    CacheClusterId = element(local.elasticache_member_clusters, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    aws_elasticache_parameter_group.default
  ]
}

resource "aws_cloudwatch_metric_alarm" "redis_memoryusage" {
  count = var.cloudwatch_alarms_enabled ? local.member_clusters_count : 0
  alarm_name = format("%s-DatabaseMemoryUsagePercent", element(local.elasticache_member_clusters, count.index))
  alarm_description = "Redis Cluster Database Memory Usage Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = var.alarm_databasememoryusage_threshold_percent

  dimensions = {
    CacheClusterId = element(local.elasticache_member_clusters, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    aws_elasticache_parameter_group.default
  ]
}

resource "aws_cloudwatch_metric_alarm" "redis_cachehitrate" {
  count = var.cloudwatch_alarms_enabled ? local.member_clusters_count : 0
  alarm_name = format("%s-CacheHitRate", element(local.elasticache_member_clusters, count.index))
  alarm_description = "Redis Cluster Cache Hit Rate Alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CacheHitRate"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"
  treat_missing_data  = "ignore"

  threshold = var.alarm_cachehitrate_threshold_percent

  dimensions = {
    CacheClusterId = element(local.elasticache_member_clusters, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    aws_elasticache_parameter_group.default
  ]
}
