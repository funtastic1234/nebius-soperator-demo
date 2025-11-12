terraform {
  required_providers {
    nebius = {
      source  = "terraform-provider.storage.eu-north1.nebius.cloud/nebius/nebius"
      version = ">=0.4"
    }
    units = {
      source  = "dstaroff/units"
      version = ">=1.1.1"
    }
  }
}

