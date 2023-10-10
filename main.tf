provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "app" {
  name     = var.resource_group_name
}

resource "azurerm_service_plan" "plan" {
  name                = var.service_plan_name
  resource_group_name = data.azurerm_resource_group.app.name
  location            = azurerm_resource_group.app.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "app" {
  name                = var.linux_web_app_name
  resource_group_name = data.azurerm_resource_group.plan.name
  location            = azurerm_service_plan.app.location
  service_plan_id     = azurerm_service_plan.app.id
  site_config {}
}