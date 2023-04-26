# context module
module "context" {
  source          = "a3linux/context/null"
  context_values  = var.context
  additional_tags = try(var.tags, {})
}

variable "context" {
  type        = map(any)
  description = "Context init values, should be overrided always"
  default = {
    env       = "dev"
    region    = "us-west-2"
    team      = "myTeam"
    service   = "myService"
    component = "myServiceCom1"
  }
}
