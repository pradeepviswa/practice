variable "instances" {
  type = map(object({
    ami_id        = string
    instance_type = string
    vm_name       = string
    env           = string
  }))
}