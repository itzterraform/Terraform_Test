data "azurerm_resource_group" "compute" {
  name = "test-rg"
}

data "azurerm_resource_group" "compute1" {
  name = "new-rg"
}

data "azurerm_key_vault" "compute" {
  name                = "newkeyvaulrejo9006"
  resource_group_name = "new-rg"
}

data "azurerm_key_vault_secret" "compute" {
  name         = "unix-password"
  key_vault_id = data.azurerm_key_vault.compute.id
}

data "azurerm_subnet" "compute" {
  name                 = "test-rg-sub"
  virtual_network_name = "test-rg-net"
  resource_group_name  = "test-rg"
}

data "azurerm_public_ip" "compute" {
  name                = "test-rg-pub"
  resource_group_name = "test-rg"
}

resource "azurerm_network_interface" "compute" {
  name                = var.interfacename
  location            = data.azurerm_resource_group.compute.location
  resource_group_name = data.azurerm_resource_group.compute.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.compute.id
    private_ip_address_allocation = "Dynamic"
    /*public_ip_address_id = data.azurerm_public_ip.compute.id*/
  }
}

resource "azurerm_linux_virtual_machine" "compute" {
  name                = var.vmname
  resource_group_name = data.azurerm_resource_group.compute.name
  location            = data.azurerm_resource_group.compute.location
  size                = "Standard_B1s"
  admin_username      = "rejo9006"
  admin_password      = data.azurerm_key_vault_secret.compute.value
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
