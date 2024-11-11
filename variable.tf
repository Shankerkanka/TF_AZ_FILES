variable "key" {
  default = "ssh_key"
}

variable "rgnew" {
  default = "terraform_rg1"
}

variable "location" {
  default = "westus2"
}
variable "address_space" {
  default = ["10.1.0.0/16"]
  type    = list(string)
}

variable "vnet_name" {
  default = "terraform_vnet"
}
variable "subnet_space" {
  default = ["10.1.0.0/24", "10.1.10.0/24"]
  type    = list(string)
}

variable "subnet_name" {
  default = "terraform_snet"

}

variable "sku" {
  default = "20.04-LTS"
}
variable "vm_name" {
  default = "sskvmfromTF"
}
variable "admin" {
  default = "azureuser"
}
variable "size" {
  default = "Standard_B1s"
}

variable "user" {
  default = "azureuser"
}

variable "nsg" {
  default = "nsg"
}
variable "nic_name" {
  default = "nic"
}
variable "pip_name" {
  default = "pip"
}

variable "ip_name" {
  default = "ip"
}


