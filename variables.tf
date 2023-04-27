variable "tags" {
  type        = map(any)
  description = "Tags"
  default     = {}
}
variable "vpc_id" {
  type        = string
  description = "VPC Id"
  default     = null
}
variable "vpc_name" {
  type        = string
  description = "VPC Name Tag"
  default     = null
}
variable "subnet_name" {
  type        = string
  description = "Subnet Name Tag"
  default     = null
}
variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
  default     = []
}
variable "elasticache_subnet_group_name" {
  type        = string
  default     = ""
  description = "ElastiCache Subnet Group Name(existed resource). If not present, the same name(replication_group_id) one will be created, but the subnets should have same AZs as the subnets mentioned above or it will be a problem."
}
variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones, if not present, will pick up form the subnets(subnet_name queired result"
  default     = []
}
variable "name" {
  type        = string
  description = "Redis Cluster name(AWS ElastiCache Replication Group Id)"
  default     = null
}
variable "description" {
  type        = string
  description = "Description"
  default     = ""
}
variable "port" {
  type        = number
  description = "Redis port, default: 6379"
  default     = 6379
}
variable "port_service" {
  type        = string
  description = "The service name(key) in port service module for redis port"
  default     = "redis"
}
variable "port_service_mappings" {
  type        = map(list(any))
  description = "A map of list to define the port service mappings. Only when the default port is NOT 6379. e.g. {myredis = [6380, 6380, \"tcp\", \"MyRedisPort\"]}, then the port_service should be myredis and the port should be 6380 to apply the security group correctly"
  default     = {}
}
variable "allowed_sources" {
  type        = list(any)
  description = "Allowed source IPs"
  default     = []
}
variable "allowed_ips" {
  description = "List of allowed ip, additional IP list to sources list"
  type        = list(string)
  default     = []
}
variable "cluster_mode_enabled" {
  type        = bool
  description = "Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
  default     = false
}
variable "cluster_size" {
  type        = number
  description = "Number cache clusters for non Cluster Mode instances"
  default     = 2
}
variable "transit_encryption_enabled" {
  type        = bool
  description = "Enable transit encryption"
  default     = true
}
variable "auth_token_param_name" {
  type        = string
  description = "SSM Parameter name which stores the auth token for transit encryption"
  default     = ""
}
variable "multi_az_enabled" {
  type        = bool
  description = "Enable Mutli AZ"
  default     = true
}
variable "automatic_failover_enabled" {
  type        = bool
  description = "Enable Automatic Failover"
  default     = true
}
variable "family" {
  type        = string
  description = "ElastiCache Redis Family for parameter group. e.g. redis5.0, redis6.x"
  default     = "redis5.0"
}
# ElastiCache Parameter Group vars
variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
  default     = []
}
variable "engine_version" {
  type        = string
  description = "ElastiCache Engine Version, should match to Parameter Group family, e.g. 5.0.6 <-> redis5.0, 6.x <-> redis6.x "
  default     = "5.0.6"
}
variable "instance_type" {
  type        = string
  description = "Node type(instance type)"
  default     = "cache.t3.micro"
}
variable "security_groups" {
  type        = list(any)
  description = "Additional Security Groups"
  default     = []
}
variable "maintenance_window" {
  type        = string
  description = "Maintenance window"
  default     = ""
}
variable "snapshot_arns" {
  type        = list(string)
  description = "A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb"
  default     = []
}
variable "snapshot_name" {
  type        = string
  description = "The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource."
  default     = null
}
variable "snapshot_window" {
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  default     = "06:30-07:30"
}
variable "snapshot_retention_limit" {
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
  default     = 0
}
variable "final_snapshot_identifier" {
  type        = string
  description = "The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made."
  default     = null
}
variable "cluster_mode_replicas_per_node_group" {
  type        = number
  description = "Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource"
  default     = 0
}
variable "cluster_mode_num_node_groups" {
  type        = number
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications"
  default     = 0
}
variable "kms_key_id" {
  type        = string
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. `at_rest_encryption_enabled` must be set to `true`"
  default     = null
}
variable "apply_immediately" {
  type        = bool
  default     = true
  description = "Apply changes immediately"
}
variable "notification_topic_arn" {
  type        = string
  default     = ""
  description = "Notification topic arn"
}
variable "create_dns_cname" {
  type        = bool
  default     = false
  description = "Create DNS CNAME or not, default is false(not create), if set to true, please set the following variables"
}
variable "zone_id" {
  type        = string
  description = "Route53 Zone Id to add DNS CNAME"
  default     = null
}
variable "zone_name" {
  type        = string
  description = "Route53 Zone Name to add DNS CNAME"
  default     = null
}
variable "is_private_zone" {
  type        = bool
  description = "Is the Route53 zone private, default is false"
  default     = false
}
variable "dns_name" {
  type        = string
  description = "DNS CNAME for the Redis Cluster, if not set, the replication group id will be used"
  default     = ""
}
variable "cloudwatch_alarms_enabled" {
  type        = bool
  description = "Create CloudWatch Alarms for the cluster"
  default     = false
}
variable "alarm_cpu_threshold_percent" {
  type        = number
  description = "CPU Utilization alarm threshold(percent)"
  default     = 75
}
variable "alarm_evictions_threshold_count" {
  type        = number
  description = "Redis Evictions Count Alarm threshold"
  default     = 100
}
variable "alarm_databasememoryusage_threshold_percent" {
  type        = number
  description = "Redis Database Memory Usage Percentage Alarm Threshold"
  default     = 90
}
variable "alarm_cachehitrate_threshold_percent" {
  type        = number
  description = "Redis Cache Hit Rate Alarm threshold"
  default     = 90
}
variable "alarm_actions" {
  type        = list(string)
  description = "Alarm actions list"
  default     = []
}
variable "ok_actions" {
  type        = list(string)
  description = "Alarm OK actions list"
  default     = []
}
