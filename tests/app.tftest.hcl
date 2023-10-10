# https://developer.hashicorp.com/terraform/language/tests

variables {
  linux_web_app_name      = "app-xxxx"
  service_plan_name       = "plan-xxxx"
  resource_group_name     = "xxxx"
  resource_group_location = "westeurope"
}

provider "azurerm" {
  features {}
}

run "unit_tests" {
  command = plan
}

run "input_validation" {
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
  command = apply
  variables {
    resource_group_name     = run.setup_resouce_group.resource_group_name
    resource_group_location = run.setup_resouce_group.resource_group_location
    service_plan_name       = "plan-integrationtest"
    linux_web_app_name      = "app-integrationtest-38742738"
  }
}


run "end_to_end_test1" {
  command = apply
  variables {
    site    = run.integration_test.default_hostname
  }  
  module {
    source = "./tests/check"
  }
}
