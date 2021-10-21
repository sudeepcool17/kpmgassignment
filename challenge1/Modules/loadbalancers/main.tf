resource "azurerm_public_ip" "azure-resource-repo" {
  name                = "WebIPForLB"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
}

resource "azurerm_lb" "azure-resource-repo" {
  name                = "WebLoadBalancer"
  location            = var.location
  resource_group_name = var.resource_group

  frontend_ip_configuration {
    name                 = "WebIPAddress"
    public_ip_address_id = azurerm_public_ip.azure-resource-repo.id
  }
}

resource "azurerm_lb_backend_address_pool" "azure-resourse-repo" {
  loadbalancer_id = azurerm_lb.azure-resource-repo.id
  name            = "BackEndAddressPool"
}
