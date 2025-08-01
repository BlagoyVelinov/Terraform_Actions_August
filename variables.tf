variable "resource_group_name" {
  type        = string
  description = "The name of resource group"
}

variable "resource_group_location" {
  type        = string
  description = "The location of the resouce group"
}

variable "app_service_plan_name" {
  type        = string
  description = "The name of app service plan"
}

variable "app_service_name" {
  type        = string
  description = "The name of app service"
}

variable "sql_server_name" {
  type        = string
  description = "The name of sql service"
}

variable "sql_database_name" {
  type        = string
  description = "The name of sql database"
}

variable "sql_admin_login" {
  type        = string
  description = "The name of sql admin login"
}

variable "sql_admin_password" {
  type        = string
  description = "The password of sql admin"
}

variable "firewall_rule_name" {
  type        = string
  description = "The name of firewall rule"
}

variable "repo_URL" {
  type        = string
  description = "The location of the GitHub repo"
}

variable "subscription_id" {
  type        = string
  description = "Azure profile ID subscription"
}