variable "resource_group_name" {
  type        = string
  description = "tfdev name in Azure"
}

variable "resource_group_location" {
  type        = string
  description = "tfdev location in Azure"
}

variable "app_service_plan_name" {
  type        = string
  description = "App Service Plan name in Azure"
}

variable "app_service_name" {
  type        = string
  description = "App Service name in Azure"
}
variable "mysql_server_name" {
  type = string
  description = "MySQL Server Name in Azure"
  
}