provider "azurerm" {
  version = "= 2.18"
  features {}
}



module "testbox-vm01" {

    source = "../Modules/compute03"
    interfacename = "test01"
    vmname = "testvm01"
    adminpass = "Bluedrag0n@12345678" 
}

module "testbox-vm02" {

    source = "../Modules/compute03"
    interfacename = "test02"
    vmname = "testvm02"
    adminpass = "Bluedrag0n@12345678" 
}
