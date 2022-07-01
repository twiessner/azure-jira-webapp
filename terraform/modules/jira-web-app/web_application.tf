
resource "azurerm_linux_web_app" "jira" {
  name                = join("-", ["app", "jira", var.env, var.location])
  resource_group_name = azurerm_resource_group.default.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.default.id

  site_config {
    application_stack {
      docker_image     = "atlassian/jira-software"
      docker_image_tag = "latest"
    }
  }

  storage_account {
    name         = "content"
    type         = "AzureFiles"
    mount_path   = "/var/atlassian/application-data/jira"
    share_name   = azurerm_storage_share.app_content.name
    access_key   = azurerm_storage_account.jira.primary_access_key
    account_name = azurerm_storage_account.jira.name
  }

  app_settings = {
    # database settings
    ATL_JDBC_URL = "jdbc:postgresql://psql-jira-dev-westeurope.postgres.database.azure.com:5432/${azurerm_postgresql_flexible_server_database.default.name}?user=v0x1wlrhhb&password={your_password}&sslmode=require"
    ATL_JDBC_USER = azurerm_postgresql_flexible_server.default.administrator_login
    ATL_JDBC_PASSWORD = azurerm_postgresql_flexible_server.default.administrator_password
    ATL_DB_DRIVER = "org.postgresql.Driver"
    ATL_DB_TYPE = "postgres72"

    #APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.ai.instrumentation_key
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "nsc" {
  app_service_id = azurerm_linux_web_app.jira.id
  subnet_id      = azurerm_subnet.subnet-app.id
}