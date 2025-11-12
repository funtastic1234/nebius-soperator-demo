terraform {
  backend "s3" {
    bucket = "tfstate-slurm-k8s-e42c4a11e06845e1a2d37776200ac933"
    key    = "slurm-k8s.tfstate"

    endpoints = {
      s3 = "https://storage.eu-north1.nebius.cloud:443"
    }
    region = "eu-north1"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
