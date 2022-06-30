resource "azurerm_virtual_network" "vnet-db" {
    name = "vnet-jira-webapp-db-westeu"
    location = local.location
    resource_group_name = local.resource_group_name
    address_space = ["172.0.10.0/24"]
    tags = local.tags
}

resource "azurerm_virtual_network" "vnet-app" {
    name = "vnet-jira-webapp-ap-westeu"
    location = local.location
    resource_group_name = local.resource_group_name
    address_space = ["172.0.20.0/24"]
}

resource "azurerm_subnet" "subnet-db" {
    name = "snet-jira-webapp-db-westeu"
    location = local.location
    resource_group_name = local.resource_group_name
    address_prefixes = ["172.0.10.0/26"]
    service_endpoints = [ "Microsoft.Storage" ]
    delegation {
        name = "subnet-delegation-db"
        service_delegation {
          name = "Microsoft.DBforPostgreSQL/flexibleServers"
          actions = [
             "Microsoft.Network/virtualNetworks/subnets/join/action",
          ]
        }
    }
}

resource "azurerm_subnet" "subnet-app" {
    name = "snet-jira-webapp-app-westeu"
    location = local.location
    resource_group_name = local.resource_group_name
    address_prefixes = ["172.0.20.0/26"]
}