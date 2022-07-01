
resource "azurerm_service_plan" "default" {
  name                = join("-", ["plan", "jira", var.env, var.location])
  resource_group_name = azurerm_resource_group.default.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
}