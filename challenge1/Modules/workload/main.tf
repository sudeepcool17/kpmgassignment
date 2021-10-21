resource "azurerm_availability_set" "availset" {
  name                = "Webaset"
  location            = azurerm_resource_group.azure-resource-repo.location
  resource_group_name = azurerm_resource_group.azure-resource-repo.name
}

resource "azurerm_network_interface" "vnic" {
  name                = "vnic${count.index}"
  count               = 4
  location            = azurerm_resource_group.azure-resource-repo.location
  resource_group_name = azurerm_resource_group.azure-resource-repo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg-assoc" {
  count                     = 4
  network_interface_id      = element(azurerm_network_interface.vnic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vnicToBePool" {
  count                   = 4
  network_interface_id    = element(azurerm_network_interface.vnic.*.id, count.index)
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backendpool.id
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                  = "vm-${count.index}"
  count                 = 4
  resource_group_name   = azurerm_resource_group.azure-resource-repo.name
  location              = azurerm_resource_group.azure-resource-repo.location
  size                  = "Standard_F2"
  admin_username        = var.vmAdminUsername
  admin_password        = var.vmAdminPassword
  availability_set_id   = azurerm_availability_set.availset.id
  network_interface_ids = [element(azurerm_network_interface.vnic.*.id, count.index)]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "rdp-access"
  location            = azurerm_resource_group.azure-resource-repo.location
  resource_group_name = azurerm_resource_group.azure-resource-repo.name

  security_rule {
    name                       = "rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "pubIp" {
  name                = "${var.appName}-pubIp"
  location            = azurerm_resource_group.azure-resource-repo.location
  resource_group_name = azurerm_resource_group.azure-resource-repo.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
  name                = "${var.appName}-lb"
  location            = azurerm_resource_group.azure-resource-repo.location
  resource_group_name = azurerm_resource_group.azure-resource-repo.name

  frontend_ip_configuration {
    name                 = "${var.appName}-feip"
    public_ip_address_id = azurerm_public_ip.pubIp.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb-backendpool" {
  resource_group_name = azurerm_resource_group.azure-resource-repo.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "BackEndAddressPool"
}


resource "azurerm_lb_rule" "lb-rule" {
  resource_group_name            = azurerm_resource_group.azure-resource-repo.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb-backendpool.id
  frontend_ip_configuration_name = "${var.appName}-feip"
}
