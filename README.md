```markdown
#               HEAD

security best pratice via Terraform & GitHub Actions
This project demonstrates how to provision an AWS EC2 instance using Terraform, configure it with Nginx, and give give this inatance read only access to an s3 bucket

in this project we also configure CloudTrail and CloudWatch with both delivering logs to an s3 bucket 
these logs are monitored by GuardDuty with alert set to notify me through an email in case of any suspicious activity

#             OVERVIEW

Terraform provisions an Amazon Linux 2 EC2 instance with Nginx 
pre-installed
Nginx serves a basic HTML file from the site/ folder
GitHub Actions deploys site updates automatically on each push to the main branch
GitHub Secrets manage SSH and EC2 connection data securely

# Project Structure

.
modules 
   ├──ec2               
     └── main.tf # Terraform configuration
     |__user_data.sh # EC2 bootstrapping script
   |__s3 
     |__main.tf
   |__security
     |__main.tf
   |__sg
     |main.tf
main.tf
provider.tf
terraform.tfvars        
variables.tf
.github/
   └── workflows/
       └── deploy.yml        # CI/CD GitHub Actions pipeline
README.md

#    Requirements
Before you begin, ensure you have:

An AWS account with access to create EC2 instances
Terraform installed locally
A GitHub account and this repository created
an s3 bucket to store your state files 
An EC2 key pair (public/private)


# Setup Instructions
1. Clone the Repo  
bash
git clone https://github.com/Alphaperry/static-site-deploy.git
cd static-site-deploy
2. Deploy the Infrastructure
bash

cd terraform
terraform init
terraform apply

3. Add GitHub Secrets
   AWS_ACCESS_KEY_ID
   AWS_SECRET_ACCESS_KEY
   AWS_REGION
   ADMIN_EMAIL #your alert/notification email
4. Push a Site Update
bash

git add .
git commit -m "First website update"
git push origin main

This triggers the GitHub Actions pipeline 

# Security Notes

Never commit private keys to the repo

Use GitHub Secrets for secure handling of SSH credentials
Configure EC2 security group to only allow trusted IPs (e.g., port 22 & 80)

   Maintainer
Ndula Perry Bofuang
Certified AWS Cloud & DevOps Engineer

#  License
This project is licensed under the MIT License
Built with  by a Cloud Engineer who automates everything.

# static-site-deploy
Static website deployed via Terraform and GitHub
Actions



