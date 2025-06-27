region = "us-east-1"
instance_type = "t2.micro"
key_name = "" #replace with the name of your ec2 key pair
security_group = {
  "ec2_sg" = {
    description = "Allow SSH and HTTP inbound traffic for web server"

    ingress = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP from anywhere"
        self        = false
      },
      {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks      = ["0.0.0.0/0"] # Replace this with your trusted IP(s)
        description     = "SSH from trusted IPs"
        self            = false
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTPS from anywhere"
        self        = false
      }
    ]
egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound"
        self        = false
      }
    ]
  }
}

