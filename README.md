A quick module create Redis with AWS ElastiCache Replication Group
===================================================================

## Resources created in this module

1. VPC Security group for Redis access control
2. ElastiCache instance with Parameter Group and Subnet Group
3. CloudWatch Alarms
4. DNS CNAME of ElastiCache instance

## About CloudWatch Alarms

According to AWS document for CloudWatch metrics of ElastiCache Redis, ![What to monitor][https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/CacheMetrics.WhichShouldIMonitor.html] and ![Best Pratice][https://aws.amazon.com/blogs/database/monitoring-best-practices-with-amazon-elasticache-for-redis-using-amazon-cloudwatch/].

This module can set up some CloudWatch Alarms for the ElastiCache Replication Group created. To enable alarms creation, please set cloudwatch_alarms_enabled = true, by default it is false. 

Alarms will be created if enabled, 

* CPUUtilization (host level: percent) and EngineCPUUtilization(Redis host level: percent) 
* DatabaseMemoryUsagePercent
* CacheHitRate (Percent)
* Evictions (Count)
* SetTypeCmdsLatency(ms) and GetTypeCmdsLatency(ms) #TODO
