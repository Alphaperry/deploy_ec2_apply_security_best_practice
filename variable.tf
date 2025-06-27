variable "region" {
  type = string
}
variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}


variable "security_group" {
  description = "security group for ec2 instance"
  type = map(object({
    description = string
    ingress = list(object({
      from_port = number
      to_port = number
      protocol = string
      description = string
      cidr_blocks = list(string)
      self = bool 
  }))
    egress = list(object({
      from_port = number
      to_port = number
      protocol = string
      description = string 
      cidr_blocks = list(string)
      self  = bool
    }))
  }))
}

variable "alert_email" {
  type = string
}