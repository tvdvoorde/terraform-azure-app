# https://developer.hashicorp.com/terraform/language/tests

variables {
  linux_web_app_name      = "app-xxxx"
  service_plan_name       = "plan-xxxx"
  resource_group_name     = "xxxx"
  resource_group_location = "westeurope"
}

provider "azurerm" {
  features {}
  subscription_id = "ea757669-674b-44c1-bf87-bd0fd0880294"
  client_id       = "e3fc25fa-e7f4-475c-b02c-8305577ed383"
  use_oidc        = true
  tenant_id       = "e2a4b012-36ad-45f2-8c5c-169f06c2f970"
}

run "unit_tests" {
    provider = azurerm
  command = plan
}

run "input_validation" {
    provider = azurerm    
  command = plan
  variables {
    linux_web_app_name      = var.linux_web_app_name
    service_plan_name       = "incorrectname"
    resource_group_name     = var.resource_group_name
    resource_group_location = var.resource_group_location
  }
  expect_failures = [var.service_plan_name]
}

run "setup_resouce_group" {
    provider = azurerm    
  command = apply
  variables {
    resource_group_name     = "rg-integrationtest"
    resource_group_location = "westeurope"
  }
  module {
    source = "./tests/setup-rg"
  }
}

run "integration_test" {
    provider = azurerm    
  command = apply
  variables {
    resource_group_name     = run.setup_resouce_group.resource_group_name
    resource_group_location = run.setup_resouce_group.resource_group_location
    service_plan_name       = "plan-integrationtest"
    linux_web_app_name      = "app-integrationtest-38742738"
  }
}


run "end_to_end_test1" {
    provider = azurerm    
  command = apply
  variables {
    site = run.integration_test.default_hostname
  }
  module {
    source = "./tests/check"
  }
}
