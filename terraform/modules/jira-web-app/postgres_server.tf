
resource "random_string" "db_user" {
  length  = 10
  upper   = false
  lower   = true
  special = false

  keepers = {
    env                 = var.env
    location            = var.location
    resource_group_name = azurerm_resource_group.default.name
  }
}

resource "random_password" "db_password" {
  length = 32

  upper   = true
  lower   = true
  special = true

  min_lower   = 5
  min_upper   = 5
  min_special = 5

  keepers = {
    env                 = var.env
    location            = var.location
    resource_group_name = azurerm_resource_group.default.name
  }
}

resource "azurerm_postgresql_flexible_server" "default" {
  name                = join("-", ["psql", "jira", var.env, var.location])
  resource_group_name = azurerm_resource_group.default.name
  location            = var.location
  version             = "11"

  private_dns_zone_id = azurerm_private_dns_zone.jira.id
  delegated_subnet_id = azurerm_subnet.subnet-db.id

  administrator_login    = random_string.db_user.result
  administrator_password = random_password.db_password.result
  zone                   = "1"

  storage_mb = 32768
  sku_name   = "B_Standard_B1ms"

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.jira
  ]
}

resource "azurerm_postgresql_flexible_server_database" "default" {
  name      = "jira-${var.env}"
  server_id = azurerm_postgresql_flexible_server.default.id
  charset   = "utf8"
  collation = "en_US.utf8"
}