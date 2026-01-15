resource "azurerm_resource_group" "rg" {
  count = var.deploy_resource_group ? 1 : 0

  name       = var.resource_group_name
  location   = var.location
  managed_by = var.managed_by
  tags       = try(var.tags.resource_group, null)
}