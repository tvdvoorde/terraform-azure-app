output "default_hostname" {
  description = "The default hostname."
  value       = azurerm_linux_web_app.app.default_hostname
}