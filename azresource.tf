
resource "azurerm_resource_group" "rg123" {

  name     = var.rg_name
  location = var.location
}
resource "azurerm_virtual_network" "vnet123" {

  name                = var.vnet123
  location            = var.location
  resource_group_name = azurerm_resource_group.rg123.name
  address_space       = var.address_space
}

resource "azurerm_subnet" "sbnet" {

  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg123.name
  virtual_network_name = azurerm_virtual_network.vnet123.name
  address_prefixes     = var.subnet_space
}

resource "azurerm_ssh_public_key" "ssh_key" {

  name                = var.ssh_key_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg123.name
  public_key          = file("~/.ssh/id_rsa.pub")
}

resource "azurerm_network_interface" "nicssk" {

  name                = var.nic_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg123.name
  ip_configuration {

    name                          = var.ip_name
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
    subnet_id                     = azurerm_subnet.sbnet.id
  }
}

resource "azurerm_public_ip" "pip" {

  name                = var.pip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg123.name
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "tfssk" {

  name                  = var.lvm_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg123.name
  admin_username        = var.adminssk
  network_interface_ids = [azurerm_network_interface.nicssk.id]
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
    #Canonical:ubuntu-24_04-lts:server:latest
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"

  }

}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg123.name

  security_rule {
    name                       = "nsgssk"
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

resource "azurerm_subnet_network_security_group_association" "nsgasoc" {
  subnet_id                 = azurerm_subnet.sbnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id

}
