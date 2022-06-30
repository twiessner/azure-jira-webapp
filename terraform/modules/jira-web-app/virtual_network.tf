
resource "azurerm_virtual_network" "default" {
  name                = "vnet-jira-webapp-db-westeu"
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/19"]
  tags                = var.tags
  location            = var.location
}

resource "azurerm_subnet" "subnet-db" {
  name                 = "snet-jira-webapp-db-westeu"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/26"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "subnet-delegation-db"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "subnet-app" {
  name                 = "snet-jira-webapp-app-westeu"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.2.0/26"]

  delegation {
    name = "subnet-web-app-db"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}