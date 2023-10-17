# https://developer.hashicorp.com/terraform/language/checks

variable "site" {}

check "inspec" {
  data "external" "inspec" {
    program = ["bash","${path.module}/test.sh","${var.site}"]
    }
  assert {
    condition     = data.external.inspec.result.passed == "true"
    error_message = "errors while testing"
  }
}

