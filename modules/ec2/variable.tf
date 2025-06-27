variable "security_group_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}
variable "linux_user" {
  type = string
  default = "ec2_user"
  
}
variable "ec2_role" {
  type = string 
  
}

variable "random_id" {
  type = string
}