variable "rg_name" {

  default = "tf_ssk"
}

variable "location" {

  default = "northeurope"
}

variable "vnet123" {

  default = "vnet123"
}

variable "address_space" {

  default = ["10.0.0.0/16"]
  type    = list(string)
}

variable "subnet_space" {

  default = ["10.0.3.0/24", "10.0.10.0/24"]
  type    = list(string)
}
variable "subnet_name" {

  default = "tf_ssk_snet"
}

variable "ssh_key_name" {

  default = "sshkey_ssk"
}

variable "nic_name" {

  default = "nicsskcard"
}
variable "ip_name" {

  default = "ip"

}

variable "pip_name" {
  default = "pip"
}
variable "lvm_name" {

  default = "lvmssktf"
}
variable "adminssk" {

  default = "azureuser"
}
variable "size" {
  default = "Standard_B1s"
}
variable "user" {
  default = "azureuser"
}
variable "nsg_name" {
  default = "nsg"
}
