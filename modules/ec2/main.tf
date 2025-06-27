
data "aws_ami" "amazon_linux_2" {
    most_recent = true
    owners = ["amazon"] # Official Amazon AMIs
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}


#Instance profile to attach IAM role to EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile-${var.random_id}"
  role = var.ec2_role
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [ var.security_group_id ] 
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    linux_user = var.linux_user
  })

  tags = {
    Name = "Terraform-Nginx-WebServer"
  }
}
# --- Elastic IP (EIP) ---
resource "aws_eip" "web_server_eip" {
  instance = aws_instance.web_server.id
  domain = "vpc" 
  tags = {
   Name = "NginxWebServerEIP"
 }
}