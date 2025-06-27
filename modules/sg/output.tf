output "security_group_ids" {
  description = "Map of security group names to their IDs"
  value = {
    for sg_key, sg in aws_security_group.web_server_sg :
    sg_key => sg.id
  }
}