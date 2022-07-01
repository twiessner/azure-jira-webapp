
resource "random_string" "sa" {
  length  = 22
  lower   = true
  upper   = false
  special = false

  keepers = {
    env                 = var.env
    location            = var.location
    resource_type       = "storage-account"
    resource-group-name = azurerm_resource_group.default.name
  }
}

resource "azurerm_storage_account" "jira" {
  name                = join("", ["st", random_string.sa.result])
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name

  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  # common security settings
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  enable_https_traffic_only        = true

  tags = var.tags
}

resource "azurerm_storage_share" "app_content" {
  name                 = "app-content"
  quota                = 50
  storage_account_name = azurerm_storage_account.jira.name
}