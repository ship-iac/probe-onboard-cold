globals {
  version = "1"
}

generate_hcl "_backend.tf" {
  content {
    terraform {
      backend "local" {
        path = ".state/${var.env}/${var.region}/terraform.tfstate"
      }
    }
  }
}

generate_hcl "_providers.tf" {
  content {
    terraform {
      required_providers {
        random = {
          source  = "hashicorp/random"
          version = "~> 3.0"
        }
      }
    }
  }
}

generate_hcl "_variables.tf" {
  content {
    variable "env" { type = string }
    variable "region" { type = string }
    variable "app_version" {
      type    = string
      default = global.version
    }
  }
}

generate_hcl "_main.tf" {
  content {
    resource "random_pet" "this" {
      keepers = {
        app_version = var.app_version
      }
    }
    output "name" {
      value = random_pet.this.id
    }
  }
}
