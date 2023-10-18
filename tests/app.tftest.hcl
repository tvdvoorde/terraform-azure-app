# https://developer.hashicorp.com/terraform/language/tests

variables {
  linux_web_app_name      = "app-xxxx"
  service_plan_name       = "plan-xxxx"
  resource_group_name     = "xxxx"
  resource_group_location = "westeurope"
  use_oidc                = false
}


provider "azurerm" {
  features {}
  subscription_id = "ea757669-674b-44c1-bf87-bd0fd0880294"
  client_id       = "e3fc25fa-e7f4-475c-b02c-8305577ed383"
  use_oidc        = true
  tenant_id       = "e2a4b012-36ad-45f2-8c5c-169f06c2f970"
}

run "unit_tests" {
  command = plan
}

run "input_validation" {
  command = plan
  variables {
    service_plan_name       = "incorrectname"
  }
  expect_failures = [var.service_plan_name]
}

run "setup_resouce_group" {
  command = apply
  variables {
    resource_group_name     = "rg-integrationtestfull"
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

  assert {
    condition = azurerm_linux_web_app.app.https_only == true
    error_message = "The web app is not configured to only use HTTPS"
  }
}


run "end_to_end_test-httpget-v1" {
  command = plan
  variables {
    site = run.integration_test.default_hostname
  }
  module {
    source = "./tests/check"
  }
}

run "end_to_end_test-httpget-v2" {
  # if you run this check on apply - it will attempt to run the module on destroy, and since it has a data, (http requires a 200 response) - it will fail
  # if you run it like end_to_end_test1, it is a check that only runs on apply
  command = plan
  variables {
    site = run.integration_test.default_hostname
  }
  module {
    source = "./tests/httpget"
  }
  assert {
    condition = data.http.site.status_code == 200
    error_message = "The web app is not responding with a 200 status code"
  }
  assert {
    condition     = strcontains(data.http.site.response_body,"Microsoft Azure App Service") == true
    error_message = "Site does not contain \"Microsoft Azure App Service\""
  }
}

run "end_to_end_test-inspec" {
  command = plan
  variables {
    site = run.integration_test.default_hostname
  }
  module {
    source = "./tests/inspec"
  }
}
