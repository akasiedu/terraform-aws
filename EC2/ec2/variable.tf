variable "common_tags" {
  type = map(any)
  default = {
    "AssetID"       = "2560"
    "AssetName"     = "Infrastracture"
    "Environment"   = "Dev"
    "Project"       = "Terraform-Project"
    "CreatedBy"     = "AKA"
    "CloudProvider" = "AWS"
  }
}

