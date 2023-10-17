  variable "site" {
    type = string
  }
  
  data "http" "site" {
    url      = "https://${var.site}"
    method   = "GET"
    retry {
        attempts = 2
        min_delay_ms = 1000
        max_delay_ms = 2000
    }
  }
