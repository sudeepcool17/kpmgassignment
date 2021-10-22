provider "azurerm" {
  features {}
}

module "resourcegroup" {
  source         = "./modules/resourcegroup"
  name           = var.name
  location       = var.location
}

module "networksetup" {
  source         = "./modules/networksetup"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  vnetcidr       = var.vnetcidr
  websubnetcidr  = var.websubnetcidr
  appsubnetcidr  = var.appsubnetcidr
  dbsubnetcidr   = var.dbsubnetcidr
}


module "networksecuritygroup" {
  source         = "./modules/networksecuritygroup"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  websubnetid  = module.networking.websubnet_id
  appsubnetid  = module.networking.appsubnet_id
  dbsubnetid   = module.networking.dbsubnet_id
}

module "workload" {
  source         = "./modules/workload"
  location = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  websubnetid = module.networking.websubnet_id
  appsubnetid = module.networking.appsubnet_id
  webhostname = var.webhostname
  webusername = var.webusername
  webospassword = var.webospassword
  apphostname = var.apphostname
  appusername = var.appusername
  appospassword = var.appospassword
}

module "backendatabase" {
  source = "./modules/backendatabase"
  location = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  Datarepo_database = var.primary_database
  Datarepo_database_version = var.Datarepo_database_version
  Datarepo_database_admin = var.Datarepo_database_admin
  Datarepo_database_password = var.Datarepo_database_password

