variable "vpc_zone_identifier" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
#variable "target_group_arns" {}
variable "tags" {}
variable "image_id" {}
variable "instance_type" {}
variable "iam_instance_profile" {}
variable "prefix" {}
variable "ec2_role" {}
variable "vpc_security_group_ids" {}
variable "health_check_type" {}

variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"

  type = list(object({
    device_name  = string
    no_device    = bool
    virtual_name = string
    ebs = object({
      delete_on_termination = bool
      encrypted             = bool
      iops                  = number
      kms_key_id            = string
      snapshot_id           = string
      volume_size           = number
      volume_type           = string
    })
  }))

  default = []
}




