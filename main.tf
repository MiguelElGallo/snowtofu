terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
      version = ">= 2.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-miguel"
    storage_account_name = "samiguel2025"
    container_name       = "tfs"
    key                  = "snowflake/tofu/terraform.tfstate"
    use_oidc        = true
    client_id     = "CLIENT_ID_PLACEHOLDER"  # This will be replaced during init
    tenant_id     = "TENANT_ID_PLACEHOLDER"  # This will be replaced during init
    subscription_id = "SUBSCRIPTION_ID_PLACEHOLDER"  # This will be replaced during init
  }
}

variable "organization_name" {
  type = string
  # Optionally, add a description:
  # description = "The name of your Snowflake organization."
}

variable "account_name" {
  type = string
  # Optionally, add a description:
  # description = "The name of your Snowflake account."
}

variable "private_key_path" {
  type = string
  # Optionally, add a description:
  # description = "The path to the private key file for Snowflake authentication."
}

locals {
  organization_name = var.organization_name
  account_name      = var.account_name
  private_key_path  = var.private_key_path
}


provider "snowflake" {
    organization_name = local.organization_name
    account_name      = local.account_name
    user              = "TERRAFORM_SVC"
    role              = "SYSADMIN"
    authenticator     = "SNOWFLAKE_JWT"
    private_key       = file(local.private_key_path)
}


resource "snowflake_database" "dummy_from_terraform" {
  name         = "TF_DEMO_DB"
  is_transient = false
}

resource "snowflake_warehouse" "dummy_warehouse_from_terraform" {
  name                      = "WH_DUMMY"
  warehouse_type            = "STANDARD"
  warehouse_size            = "XSMALL"
  max_cluster_count         = 1
  min_cluster_count         = 1
  auto_suspend              = 60
  auto_resume               = true
  enable_query_acceleration = false
  initially_suspended       = true
}

