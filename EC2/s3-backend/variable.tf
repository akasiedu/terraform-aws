variable "common_tags" {
  type = map(any)
  default = {
    "AssetID"       = "2560"
    "AssetName"     = "infrastracture"
    "Environment"   = "dev"
    "Project"       = "terraform-project"
    "CreatedBy"     = "AKA"
    "CloudProvider" = "AWS"
  }
}

