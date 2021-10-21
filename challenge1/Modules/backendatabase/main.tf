resource "azurerm_sql_server" "Datarepo" {
    name = var.Datarepo_database
    resource_group_name = var.resource_group
    location = var.location
    version = var.Datarepo_database_version
    administrator_login = var.Datarepo_database_admin
    administrator_login_password = var.Datarepo_database_password
}

resource "azurerm_sql_database" "db" {
  name                = "db"
  resource_group_name = var.resource_group
  location            = var.location
  server_name         = azurerm_sql_server.primary.name
}
