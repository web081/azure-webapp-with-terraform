
#create resources group
resource "azurerm_resource_group" "tfdev" {
  name     =  var.resource_group_name
  location = var.resource_group_location

  tags={
       environment = "production"
  }
}
#create service plan and use free resources for web app
resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.tfdev.name
  location            = azurerm_resource_group.tfdev.location
  os_type             = "Linux"
  sku_name            = "P1v3"
}

#create web linux app
resource "azurerm_linux_web_app" "app" {
  name                = var.app_service_name
  resource_group_name = azurerm_resource_group.tfdev.name
  location            = azurerm_resource_group.tfdev.location
  service_plan_id     = azurerm_service_plan.plan.id
  
  #use application stack of nginx service
  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
  }
    #connect to mysql server database
  connection_string {
    name  = "Database"
    type  = "MySql"
    value = "Server=tcp:azurerm_mysql_server.mysql.fully_qualified_domain_name Database=azurerm_mysql_database.db.name;User ID=azurerm_mysql_server.mysql.administrator_login;Password=azurerm_mysql_server.mysql.administrator_login_password;Trusted_Connection=False;Encrypt=True;"
  }


 }

# create a new database mysql server and make it highly available
  resource "azurerm_mysql_server" "mysql" {
  name                = var.mysql_server_name
  location            = azurerm_resource_group.tfdev.location
  resource_group_name = azurerm_resource_group.tfdev.name

  administrator_login          = "mysqladm"
  administrator_login_password = "A@Sh1CoR3!"
  ssl_enforcement_enabled      = true

  sku_name   = "GP_Gen4_4"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

#create a new database called webapp to connect applications
resource "azurerm_mysql_database" "db" {
  name                = "webapp"
  resource_group_name = azurerm_resource_group.tfdev.name
  server_name         = "03mysqlserver99"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}


