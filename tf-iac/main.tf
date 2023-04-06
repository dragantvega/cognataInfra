terraform {
  backend "azurerm" {
    resource_group_name  = "cognata-test"
    storage_account_name = "cognatastoragetest"
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

# resource "azurerm_network_security_group" "cognata_nsg" {
#   name                = "cognata-nsg"
#   location            = var.location
#   resource_group_name = var.resource_group

#   security_rule {
#     name                       = "allow-ssh"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

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
  vm_size               = "Standard_A2_v2"
  delete_os_disk_on_termination = true


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
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
    destination = "/home/adminuser/install.sh"
  }
  provisioner "file" {
    source      = "./ansible/playbook.yaml"
    destination = "/home/adminuser/playbook.yaml"
  }
  provisioner "file" {
    source = "azure_agent.sh"
    destination = "/home/adminuser/azure_agent.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/adminuser/install.sh",
      "chmod +x /home/adminuser/azure_agent.sh",
      "/home/adminuser/install.sh", 
      "ansible-playbook -c local playbook.yaml",
      "export TOKEN=${var.azure_token} &&  /home/adminuser/azure_agent.sh"
    ]
    
  }

}