terraform {
  backend "azurerm" {
    resource_group_name  = "cognata-1"
    storage_account_name = "cognatastorage1"
    container_name       = "cognata-state"
    key                  = "cognata.tfstate"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.project}-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group
}

# Create a public IP address
resource "azurerm_public_ip" "publicip" {
  name                = "${var.project}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.project}-network-interface"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "${var.project}-ip-config"
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.publicip.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.project}-virtual-machine"
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.project}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.project}-vm"
    admin_username = "adminuser"
    admin_password = "Adminpassword%21"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  connection {
    type     = "ssh"
    user     = "adminuser"
    password = "Adminpassword%21"
    host     = azurerm_public_ip.publicip.ip_address
  }
  provisioner "file" {
    source      = "./ansible/install.sh"
    destination = "/home/ubuntu/install.sh"
  }

}