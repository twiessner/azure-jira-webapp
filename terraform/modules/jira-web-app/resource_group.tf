
resource "azurerm_resource_group" "default" {
  location = var.location
  name     = join("-", ["rg", "jira", var.env, var.location])
  tags     = var.tags
}