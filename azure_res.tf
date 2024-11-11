resource "azurerm_resource_group" "rgnew" {
  location = var.location
  name     = var.rgnew
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rgnew.name
  address_space       = var.address_space
  location            = var.location

}

resource "azurerm_subnet" "sbnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rgnew.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_space
}


resource "azurerm_ssh_public_key" "ssh" {
  name                = var.key
  resource_group_name = azurerm_resource_group.rgnew.name
  location            = var.location
  public_key          = file("~/.ssh/id_rsa.pub")

}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = azurerm_resource_group.rgnew.name
  location            = var.location
  ip_configuration {
    name                          = var.ip_name
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
    subnet_id                     = azurerm_subnet.sbnet.id
  }
}
resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = azurerm_resource_group.rgnew.name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "lvm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rgnew.name
  location            = var.location

  admin_username        = var.admin
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.size

  admin_ssh_key {
    public_key = file("~/.ssh/id_rsa.pub")
    username   = var.user
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"

  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg
  location            = azurerm_resource_group.rgnew.location
  resource_group_name = azurerm_resource_group.rgnew.name

  security_rule {
    name                       = "sshport"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "nsgasoc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

