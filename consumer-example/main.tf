provider "azurerm" {
  features {}
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "test" {
  name     = "test"
  location = "westeurope"
}

module "app" {
  source                  = "github.com/tvdvoorde/terraform-azure-app"
  linux_web_app_name      = "app-${random_id.suffix.hex}"
  service_plan_name       = "plan-myappserviceplan1"
  resource_group_name     = azurerm_resource_group.test.name
  resource_group_location = azurerm_resource_group.test.location
}

check "inspec" {
  data "external" "inspec" {
    program = ["bash","./test.sh","${module.app.default_hostname}"]
    }
  assert {
    condition     = data.external.inspec.result.passed == "true"
    error_message = "errors while testing"
  }
}

