# https://developer.hashicorp.com/terraform/language/checks

variable "site" {}

check "response" {
  data "http" "site" {
    url      = "https://${var.site}"
    retry {
        attempts = 2
        min_delay_ms = 1000
        max_delay_ms = 2000
    }
  }

  assert {
    condition     = data.http.site.status_code == 200
    error_message = "Site is returning ${data.http.site.status_code} instead of 200"
  }

  assert {
    condition     = strcontains(data.http.site.response_body,"Microsoft Azure App Service") == true
    error_message = "Site does not contain \"Microsoft Azure App Service\""
  }  
}
