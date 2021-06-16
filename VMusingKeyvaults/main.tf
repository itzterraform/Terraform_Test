provider "azurerm" {
  version = "= 2.18"
  features {}
}


module "testbox-vm01" {

    source = "../Modules/compute03"
    interfacename = "test02"
    vmname = "testvm02"
}