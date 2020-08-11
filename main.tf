provider "aws" {
  version = "3.1.0"

  region = var.region
}

#----------------------------------------------------------------
# Data sources to get VPC, subnet, security group and AMI details 
#----------------------------------------------------------------
data "aws_vpc" "default" {

  tags = {
    Name = "${var.vpc_name}"
  }
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "*${var.subnet_prefix}*"
  }
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  owners = [var.ami_owner]
}

data "aws_security_group" "sg" {

  tags = {
    Name = var.sg_default
  }
}

#--------------------------------------------------------------
# EC2 Elasticsearch Nodes
#--------------------------------------------------------------
module "ec2_elasticsearch" {
  source = "./terraform/modules/asg"

  block_device_mappings = [{
    device_name  = "/dev/xvdb"
    no_device    = null
    virtual_name = null
    ebs = {
      encrypted             = true
      volume_size           = 8
      delete_on_termination = true
      iops                  = null
      kms_key_id            = null
      snapshot_id           = null
      volume_type           = "gp2"
    }
  }]

  max_size               = 3
  min_size               = 3
  desired_capacity       = 3
  health_check_type      = "EC2"
  instance_type          = "t2.small"
  vpc_zone_identifier    = data.aws_subnet_ids.subnets.ids
  image_id               = data.aws_ami.ami.id
  vpc_security_group_ids = [data.aws_security_group.sg.id]
  iam_instance_profile   = var.iam_instance_profile
  prefix                 = var.prefix
  ec2_role               = var.elastic_ec2_role

  tags = merge(var.tags, map("Name", format("%s-%s", var.prefix, var.elastic_ec2_role)))
}

#--------------------------------------------------------------
# EC2 Java App Nodes
#--------------------------------------------------------------
module "ec2_javaapp" {
  source = "./terraform/modules/asg"

  block_device_mappings = [{
    device_name  = "/dev/xvdb"
    no_device    = null
    virtual_name = null
    ebs = {
      encrypted             = true
      volume_size           = 8
      delete_on_termination = true
      iops                  = null
      kms_key_id            = null
      snapshot_id           = null
      volume_type           = "gp2"
    }
  }]

  max_size               = 2
  min_size               = 2
  desired_capacity       = 2
  health_check_type      = "EC2"
  instance_type          = "t2.small"
  vpc_zone_identifier    = data.aws_subnet_ids.subnets.ids
  image_id               = data.aws_ami.ami.id
  vpc_security_group_ids = [data.aws_security_group.sg.id]
  iam_instance_profile   = var.iam_instance_profile
  prefix                 = var.prefix
  ec2_role               = var.javaapp_ec2_role

  tags = merge(var.tags, map("Name", format("%s-%s", var.prefix, var.javaapp_ec2_role)))
}
