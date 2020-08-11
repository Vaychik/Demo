#--------------------------------------------------------------
# General variables
#--------------------------------------------------------------
region = "us-east-1"

#--------------------------------------------------------------
# VPC settings
#--------------------------------------------------------------
vpc_name      = "vpc-default"
subnet_prefix = "sn-default"
sg_default    = "sg-default"

#--------------------------------------------------------------
# AMI image
#--------------------------------------------------------------
ami_name  = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server*" ### !!!!!!!!!!!!!!!!!!!!!!!!!
ami_owner = "679593333241"

#--------------------------------------------------------------
# Launch Template Setting
#--------------------------------------------------------------
iam_instance_profile = "elastic-instance-profile"
instance_type        = "t2.micro"
prefix               = "elastic"

#--------------------------------------------------------------
# Tags - NEED TO CLARIFY REGARDING RESOURCE TAGS
#--------------------------------------------------------------
tags = {
  Brand                = "Cerner.com"
  Team                 = "Nomenclature"
  CostCenter           = "???" # TO CLARIFY
  LaunchedBy           = "terraform-api"
  Application          = "Terraform"
  AssetProtectionLevel = "99"
  DataClassification   = "Confidential"
  Environment          = "Development"
}