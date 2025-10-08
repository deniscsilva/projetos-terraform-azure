variable "location" {
  description = "Azure region where the resources will be created"
  type        = string
}

variable "vms_config" {
  description = "A map of VM configurations"
  type = map(object({
    subnet_cidr = string
  }))
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "rg-dcs-linux-02"
}

variable "virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "dcs-lnx2-vnet"
}

variable "subnet_name_prefix" {
  description = "The prefix for the subnet name."
  type        = string
  default     = "dcs-lnx2-subnet"
}

variable "network_security_group_name_prefix" {
  description = "The prefix for the network security group name."
  type        = string
  default     = "dcs-lnx2-nsg"
}

variable "public_ip_name_prefix" {
  description = "The prefix for the public IP name."
  type        = string
  default     = "dcs-lnx2-pip"
}

variable "network_interface_name_prefix" {
  description = "The prefix for the network interface name."
  type        = string
  default     = "dcs-lnx2-nic"
}

variable "virtual_machine_name_prefix" {
  description = "The prefix for the virtual machine name."
  type        = string
  default     = "dcs-lnx2-vm"
}

variable "vnet_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "security_rules" {
  description = "A list of security rules to apply to the network security group."
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
  default = [
    {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTPS"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}