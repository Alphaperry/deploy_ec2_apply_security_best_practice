output "instance_puplic_ip" {
  value = aws_instance.web_server.public_ip
}

output "eip" {
  value =  aws_eip.web_server_eip.id
}