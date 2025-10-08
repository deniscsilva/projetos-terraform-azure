data "azurerm_key_vault" "dcs_keyvault" {
  name                = var.keyvault_name
  resource_group_name = var.rg_kv
}

data "azurerm_key_vault_secret" "value_keyvault" {
  name         = var.keyvault_value_name
  key_vault_id = data.azurerm_key_vault.dcs_keyvault.id
}

resource "azurerm_resource_group" "rg_vm_linux" {
  name     = var.rg_name
  location = var.location
}


resource "azurerm_virtual_network" "dcs_vnet01" {
  name                = var.vnet_name
  address_space       = var.cidr_block
  location            = azurerm_resource_group.rg_vm_linux.location
  resource_group_name = azurerm_resource_group.rg_vm_linux.name
}

resource "azurerm_subnet" "dcs_snet01" {
  name                 = var.snet_name
  resource_group_name  = azurerm_resource_group.rg_vm_linux.name
  virtual_network_name = azurerm_virtual_network.dcs_vnet01.name
  address_prefixes     = var.subnet
}

resource "azurerm_network_interface" "dcs_nic01" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg_vm_linux.location
  resource_group_name = azurerm_resource_group.rg_vm_linux.name

  ip_configuration {
    name                          = var.ip_configuration
    subnet_id                     = azurerm_subnet.dcs_snet01.id
    private_ip_address_allocation = var.type_allocation
    public_ip_address_id          = azurerm_public_ip.dcs_public01.id
  }
}

resource "azurerm_public_ip" "dcs_public01" {
  name                = var.publicip_name
  resource_group_name = azurerm_resource_group.rg_vm_linux.name
  location            = azurerm_resource_group.rg_vm_linux.location
  allocation_method   = var.allocation_method
}

resource "azurerm_linux_virtual_machine" "dcs_vm_linux01" {
  name                            = var.vm_name
  resource_group_name             = azurerm_resource_group.rg_vm_linux.name
  location                        = azurerm_resource_group.rg_vm_linux.location
  size                            = var.size_vm
  admin_username                  = var.admin_user
  admin_password                  = data.azurerm_key_vault_secret.value_keyvault.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.dcs_nic01.id,
  ]

  #admin_ssh_key {
  #  username   = "adminuser"
  #  public_key = file("~/.ssh/id_rsa.pub")
  # }

  os_disk {
    caching              = var.caching_rw
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.image_version
  }
}

# Cria o NSG
resource "azurerm_network_security_group" "vm_linux_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg_vm_linux.location
  resource_group_name = azurerm_resource_group.rg_vm_linux.name

  security_rule {
    name                       = "dcs_rulename"
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

# Associa o NSG à sub-rede
resource "azurerm_subnet_network_security_group_association" "vm_linux_subnet_assoc" {
  subnet_id                 = azurerm_subnet.dcs_snet01.id
  network_security_group_id = azurerm_network_security_group.vm_linux_nsg.id
}
