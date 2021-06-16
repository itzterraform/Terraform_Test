resource "azurerm_resource_group" "compute" {
  name     = var.env
  location = var.locat
}

resource "azurerm_virtual_network" "compute" {
  name                = "${var.env}-net"
  address_space       = ["10.0.0.0/23"]
  location            = azurerm_resource_group.compute.location
  resource_group_name = azurerm_resource_group.compute.name
}

resource "azurerm_subnet" "compute" {
  name                 = "${var.env}-sub"
  resource_group_name  = azurerm_resource_group.compute.name
  virtual_network_name = azurerm_virtual_network.compute.name
  address_prefixes     = ["10.0.0.0/24"]
}


resource "azurerm_public_ip" "compute" {
  name                = "${var.env}-pub"
  resource_group_name = azurerm_resource_group.compute.name
  location            = azurerm_resource_group.compute.location
  allocation_method   = "Static"

  tags = {
    environment = "test"
  }
}