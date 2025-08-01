terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "random_integer" "randomInt" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "argroup" {
  name     = "${var.resource_group_name}${random_integer.randomInt.result}"
  location = var.resource_group_location
}

resource "azurerm_service_plan" "asplan" {
  name                = "${var.app_service_plan_name}${random_integer.randomInt.result}"
  resource_group_name = azurerm_resource_group.argroup.name
  location            = azurerm_resource_group.argroup.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "alwapp" {
  name                = "${var.app_service_name}${random_integer.randomInt.result}"
  resource_group_name = azurerm_resource_group.argroup.name
  location            = azurerm_service_plan.asplan.location
  service_plan_id     = azurerm_service_plan.asplan.id

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.amserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.amsdatabase.name};User ID=${azurerm_mssql_server.amserver.administrator_login};Password=${azurerm_mssql_server.amserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_mssql_server" "amserver" {
  name                         = "${var.sql_server_name}${random_integer.randomInt.result}"
  resource_group_name          = azurerm_resource_group.argroup.name
  location                     = azurerm_resource_group.argroup.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "amsdatabase" {
  name           = "${var.sql_database_name}${random_integer.randomInt.result}"
  server_id      = azurerm_mssql_server.amserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "amfrule" {
  name             = var.firewall_rule_name
  server_id        = azurerm_mssql_server.amserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "asscontrol" {
  app_id   = azurerm_linux_web_app.alwapp.id
  repo_url = var.repo_URL
  branch   = "main"
}
