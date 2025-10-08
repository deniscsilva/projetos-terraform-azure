data "azurerm_key_vault" "dcs_keyvault" {
  name                = "kv-dcs-01"
  resource_group_name = "rg-dcs-kv"
}

data "azurerm_key_vault_secret" "value_keyvault" {
  name         = "dcs-secret"
  key_vault_id = data.azurerm_key_vault.dcs_keyvault.id
}

resource "azurerm_resource_group" "rg_vm_win" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_network_security_group" "nsg_win" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg_vm_win.location
  resource_group_name = azurerm_resource_group.rg_vm_win.name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_virtual_network" "vnet_win" {
  name                = var.vnet_name
  address_space       = var.cidr_win
  location            = azurerm_resource_group.rg_vm_win.location
  resource_group_name = azurerm_resource_group.rg_vm_win.name
}

resource "azurerm_subnet" "snet_win" {
  count                = length(var.snet_cidr)
  name                 = "${var.snet_name}-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.rg_vm_win.name
  virtual_network_name = azurerm_virtual_network.vnet_win.name
  address_prefixes     = [var.snet_cidr[count.index]]
}

resource "azurerm_subnet_network_security_group_association" "snet_association_win" {
  count                     = length(azurerm_subnet.snet_win)
  subnet_id                 = azurerm_subnet.snet_win[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg_win.id
}

resource "azurerm_network_interface" "nic_win" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg_vm_win.location
  resource_group_name = azurerm_resource_group.rg_vm_win.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.snet_win[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_win.id
  }
}

resource "azurerm_public_ip" "public_ip_win" {
  name                = var.pip_win
  location            = azurerm_resource_group.rg_vm_win.location
  resource_group_name = azurerm_resource_group.rg_vm_win.name
  allocation_method   = "Static"
}

resource "azurerm_windows_virtual_machine" "vm_win" {
  name                = var.vm_win_name
  location            = azurerm_resource_group.rg_vm_win.location
  resource_group_name = azurerm_resource_group.rg_vm_win.name
  size                = var.sku_size
  computer_name       = var.hostname_win
  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault_secret.value_keyvault.value
  network_interface_ids = [
    azurerm_network_interface.nic_win.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "data_disk" {
  for_each             = { for i, size in var.data_disk_size_win : i => size }
  name                 = "datadisk${each.key + 1}"
  location             = azurerm_resource_group.rg_vm_win.location
  resource_group_name  = azurerm_resource_group.rg_vm_win.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = each.value
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  for_each           = azurerm_managed_disk.data_disk
  managed_disk_id    = each.value.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm_win.id
  lun                = each.key
  caching            = "ReadWrite"
}





 