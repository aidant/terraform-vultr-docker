# Terraform Vultr Docker

## Quick Setup

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.31.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.1"
    }
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.11.4"
    }
  }
}

module "restic_repository" {
  source = "github.com/aidant/terraform-vultr-docker"
}
```
