variable "rg_name" {
  description = "Nome do resource group"
  type        = string
}

variable "rg_location" {
  description = "Local do resource group"
  type        = string
}

variable "nsg_name" {
  description = "Nome do grupo de segurança"
  type        = string
}

variable "nsg_rules" {
  description = "Grupo de segurança, regras"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))

}

variable "vnet_name" {
  description = "Nome da vnet"
  type        = string
}

variable "cidr_win" {
  description = "Rede"
  type        = list(string)
}

variable "snet_cidr" {
  description = "Subnets"
  type        = list(string)
}

variable "snet_name" {
  description = "Nome das subnets"
  type        = string

}

variable "nic_name" {
  description = "Nome da interface de rede"
  type        = string
}

variable "pip_win" {
  description = "Nome do ip público"
  type        = string
}

variable "vm_win_name" {
  description = "Nome da maquina virtual"
  type        = string
}

variable "sku_size" {
  description = "Tamanho da VM"
  type        = string
}

variable "hostname_win" {
  description = "Nome do host"
  type        = string
}

variable "data_disk_size_win" {
  description = "Discos adicionais"
  type        = list(number)
  default     = [128, 256]
}
