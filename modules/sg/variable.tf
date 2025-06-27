# variable "security_group" {
#   description = "Map of security groups with ingress and egress rules"
#   type =map(object({
#     ingress = object(listt{
#       from_port   = number
#       to_port     = number
#       protocol    = string
#       description = string
#       cidr_blocks = optional(list(string), []) 
#       self        = bool
#     }))

#     egress = list(object({
#       from_port   = number
#       to_port     = number
#       protocol    = string
#       description = string
#       cidr_blocks = optional(list(string), [])
#       self        = bool
#     }))
#   })
# }

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