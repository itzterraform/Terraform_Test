resource "azurerm_resource_group" "compute" {
  name     = var.rg
  location = var.location
}

resource "azurerm_virtual_network" "compute" {
  name                = "${var.rg}-net"
  address_space       = ["10.0.0.0/23"]
  location            = azurerm_resource_group.compute.location
  resource_group_name = azurerm_resource_group.compute.name
}

resource "azurerm_subnet" "compute" {
  name                 = "${var.rg}-sub"
  resource_group_name  = azurerm_resource_group.compute.name
  virtual_network_name = azurerm_virtual_network.compute.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "compute" {
  name                = "${var.rg}-nic"
  location            = azurerm_resource_group.compute.location
  resource_group_name = azurerm_resource_group.compute.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.compute.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "compute" {
  name                = var.name
  resource_group_name = azurerm_resource_group.compute.name
  location            = azurerm_resource_group.compute.location
  size                = "Standard_B1s"
  admin_username      = "testuser"
  admin_password      = var.adminpass
  disable_password_authentication = "false"
  network_interface_ids = [
    azurerm_network_interface.compute.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
 
}