# terraform-azure-app

terraform-azure-app

## works but not on destroy

In app.tftest.hcl

```

run "end_to_end_test2" {
  command = apply
  variables {
    site    = run.integration_test.default_hostname
  }  
  module {
    source = "./tests/data"
  }
  assert {
    condition     = data.http.site.status_code == 200
    error_message = "No 200 return"
  }
}


```
