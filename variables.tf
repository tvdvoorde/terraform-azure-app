variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "service_plan_name" {
  type = string
  description = "Specifies the app service plan name - must start with \"plan-\"."

  validation {
    condition     = substr(var.image_id, 0, 5) == "plan-"
    error_message = "The plan name must start with \"plan-\"."
  }  
}


}

variable "linux_web_app_name" {
  type = string
}