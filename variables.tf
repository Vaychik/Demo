#--------------------------------------------------------------
# General variables
#--------------------------------------------------------------
variable "region" {}

#--------------------------------------------------------------
# VPC settings
#--------------------------------------------------------------
variable "vpc_name" {
  description = "Name of the VPC"
}
variable "subnet_prefix" {
  description = "Prefix of the default subnets"
}
variable "sg_default" {
  description = "Default security group"
}

#--------------------------------------------------------------
# AMI image
#--------------------------------------------------------------
variable "ami_name" {
  description = "Default AMI is Amazon Linux"
}
variable "ami_owner" {
  description = "Owner of the AMI"
}

#--------------------------------------------------------------
# LT setting
#--------------------------------------------------------------
variable "iam_instance_profile" {
  description = "Instance profile to attach to EC2"
}
variable "elastic_ec2_role" {
  description = "Role of the ES instance"
  default     = "search"
}
variable "javaapp_ec2_role" {
  description = "Role of the Java App instance"
  default     = "javaapp"
}
variable "instance_type" {}
variable "prefix" {}

#--------------------------------------------------------------
# ASG variables
#--------------------------------------------------------------
#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------
variable "tags" {}