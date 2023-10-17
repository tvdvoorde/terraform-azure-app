resource "azurerm_service_plan" "app" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "app" {
  name                = var.linux_web_app_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  service_plan_id     = azurerm_service_plan.app.id
  https_only          = true
  site_config {}

  lifecycle {

      precondition {
      condition     = azurerm_service_plan.app.os_type == "Linux"
      error_message = "Must be Linux"
      }
      postcondition {
      condition     = self.https_only == true
      error_message = "Must also be HTTP"
    }
  }

}
