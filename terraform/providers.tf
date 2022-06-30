
provider "azurerm" {
  features {}

  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  backend "azurerm" {
    client_id = var.client_id
    client_secret = var.client_secret
    resource_group_name = "rg_jira_webapp_poc"
    storage_account_name = "stjirawebapppoc"
    container_name = "tfstate"
    key = "jira_webapp_poc.tfstate"
  }
}