  variable "site" {
    type = string
  }
  

data "dns_a_record_set" "site" {
  host = var.site
}
