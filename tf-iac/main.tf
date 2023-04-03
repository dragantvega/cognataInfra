terraform {
  backend "azurerm" {
    resource_group_name  = "cognata-1"
    storage_account_name = "cognatastorage1"
    container_name       = "cognata-state"
    key                  = "cognata.tfstate"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
}

provider "azurerm" {
  features {}
}