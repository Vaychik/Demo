#--------------------------------------------------------------
# Data
#--------------------------------------------------------------

#--------------------------------------------------------------
# ASG
#--------------------------------------------------------------
/*
resource "aws_autoscaling_group" "this" {

  name                 = format("%s-%s-%d", var.prefix, var.elasticsearch_ec2_role)
  availability_zones   = [element(data.aws_availability_zones.available.names, count.index + 1)]
  vpc_zone_identifier  = var.vpc_zone_identifier
  launch_configuration = var.launch_configuration
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity

  target_group_arns = var.target_group_arns

  dynamic "tag" {
    for_each = merge(var.tags, map("Name", format("%s-%s-%d", var.prefix, var.elasticsearch_ec2_role, count.index + 1)))
    content {
      key   = tag.key
      value = tag.value

      propagate_at_launch = true
    }
  }
}

resource "aws_launch_configuration" "this" {
  name                 = format("%s-%s", var.prefix, var.elasticsearch_ec2_role)
  image_id             = var.image_id
  instance_type        = var.instance_type
  iam_instance_profile = var.iam_instance_profile
  key_name             = var.elasticsearch_keypair_name
  security_groups      = var.security_groups
  placement_tenancy    = var.placement_tenancy ############# NOT NEEDED

  lifecycle {
    create_before_destroy = true
  }
}
*/
##################
resource "aws_iam_instance_profile" "this" {
  name = var.iam_instance_profile
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name = var.ec2_role

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_launch_template" "this" {
  name = format("%s-%s", var.prefix, var.ec2_role)

  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  ebs_optimized          = false

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = lookup(block_device_mappings.value, "device_name", null)
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = flatten(list(lookup(block_device_mappings.value, "ebs", [])))
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
          encrypted             = lookup(ebs.value, "encrypted", null)
          iops                  = lookup(ebs.value, "iops", null)
          kms_key_id            = lookup(ebs.value, "kms_key_id", null)
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", null)
        }
      }
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  tag_specifications {
    resource_type = "instance"

    tags = var.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = var.tags
  }
}

resource "aws_autoscaling_group" "this" {
  vpc_zone_identifier = var.vpc_zone_identifier
  health_check_type   = var.health_check_type
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}