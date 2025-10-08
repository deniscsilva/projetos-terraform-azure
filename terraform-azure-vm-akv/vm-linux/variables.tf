# Variáveis do bloco Key Vault
variable "keyvault_name" {
  description = "Nome do key vault"
  type        = string
}

variable "rg_kv" {
  description = "rg do key vault"
  type        = string
}

# Variáveis do bloco Key Vault Secret
variable "keyvault_value_name" {
  description = "Nome do key vault secret"
  type        = string
}

# Variáveis do resource group da VM
variable "rg_name" {
  description = " Nome do resource group da VM"
  type        = string
}

variable "location" {
  description = "Região do resource group da VM"
  type        = string
}

# Variáveis da VNET
variable "vnet_name" {
  description = "Nome da VNET"
  type        = string
}

variable "cidr_block" {
  description = "Rede - CIDR"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# Variáveis da subnet
variable "snet_name" {
  description = "Nome da subnet"
  type        = string
}

variable "subnet" {
  description = "Rede interna da VNET"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

# Variáveis da interface de rede
variable "nic_name" {
  description = "Nome da NIC"
  type        = string
}

variable "ip_configuration" {
  description = "Nome do tipo de alocação de IP"
  type        = string
}

variable "type_allocation" {
  description = "Tipo de alocação de IP"
  type        = string
}

# Variáveis do ip publico
variable "publicip_name" {
  description = "Nome do public ip"
  type        = string
}

variable "allocation_method" {
  description = " Tipo do IP público static"
  type        = string
}

# Variáveis da máquina virtual linux
variable "vm_name" {
  description = "Nome da VM"
  type        = string
}

variable "size_vm" {
  description = "Tamnho da VM"
  type        = string
}

variable "admin_user" {
  description = " User admin"
  type        = string
}

# Variáveis do valor do disco
variable "caching_rw" {
  description = " Tipo read and white"
  type        = string
}

variable "storage_account_type" {
  description = " Tipo do disco"
  type        = string
}

# Varáveis da imagem
variable "publisher" {
  description = " Owner da imagem"
  type        = string
}

variable "offer" {
  description = "Imagem"
  type        = string
}

variable "sku" {
  description = "sku version"
  type        = string
}

variable "image_version" {
  description = "  version"
  type        = string
}

variable "nsg_name" {
  description = "Nome ddo nsg"
  type        = string
}

