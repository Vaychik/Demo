variable "environment" {
  default = "Development"
}
variable "region" {
  default = "us-east-1"
}
variable "acl" {
  default = "private"
}
variable "tags" {

  default = {
    Brand                = "Cerner.com"
    Team                 = "Nomenclature_Search"
    CostCenter           = "???" ### TO CLARIFY
    LaunchedBy           = "terraform-api"
    Application          = "Terraform"
    AssetProtectionLevel = "99"
    DataClassification   = "Confidential"
  }
}



