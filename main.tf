# Goal: To provision an EC2 instance, configure its security group, install a web server using
#user data, and assign a static public IP address (Elastic IP)

# ec2 will only have access to list all buckets and get objects from them 

module "s3" {
  source = "./modules/s3"
}

module "security" {
  source = "./modules/security"
  random_id = module.s3.random_id
  cloudtrail_logs_name = module.s3.cloudtrail_logs_name
  alert_email = var.alert_email
  region = var.region

}

module "security_group" {
  source = "./modules/sg"
  security_group = var.security_group

}

module "ec2" {
  source = "./modules/ec2"
  instance_type = var.instance_type
  key_name = var.key_name
  security_group_id = module.security_group.security_group_ids["ec2_sg"]
  ec2_role = module.s3.ec2_role
  random_id = module.s3.random_id
}