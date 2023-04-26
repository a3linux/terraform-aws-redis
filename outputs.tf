output "redis_endpoint" {
  value         = redis_endpoint
  description   = "The redis replication group name(id)"
}

output "redis_fqdn" {
  value         = local.redis_fqdn
  description   = "The reids FQDN if DNS CNAME is created"
}
