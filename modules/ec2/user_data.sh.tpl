
#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx
echo "<h1>Hello from your Terraform-managed EC2 Web Server!</h1>" > /usr/share/nginx/html/index.html

