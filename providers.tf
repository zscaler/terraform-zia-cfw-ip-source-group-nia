terraform {
  required_providers {
    zia = {
      source  = "zscaler/zia"
      version = ">=2.3.4"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.2.0"
    }
  }
  required_version = ">= 0.13"
}
