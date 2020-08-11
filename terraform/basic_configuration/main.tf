### Create S3 bucket & DynamoDB table for Elasticsearch Cluster ###
module "state_bucket" {
  source = "../modules/s3"

  bucket = "terraform-remote-state-elasticsearch"
  region = var.region
  acl    = var.acl

  tags = merge(var.tags, map("Name", "Elasticsearch Terraform Remote State Bucket"), map("Environment", var.environment))
}

module "lock_table" {
  source = "../modules/dynamodb"

  name = "terraform-locks-elasticsearch"

  tags = merge(var.tags, map("Name", "Nomenclature Search Lock Table"), map("Environment", var.environment))
}