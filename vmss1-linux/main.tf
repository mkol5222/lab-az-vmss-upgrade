# Minimal Ubuntu LTS diagnostics VM added to the EXISTING network created by vmss1.
#  - Reuses vmss1's "labvmssup-vnet" (no new VNet is created here).
#  - Creates a new "linux-subnet" inside that VNet.
#  - Attaches a DEDICATED route table to the subnet (empty for now, to be
#    modified later for custom routing/diagnostics).
#  - Hardcoded admin password (lab/troubleshooting use only).

locals {
  envId    = var.envId
  location = "westeurope"

  # Existing network created by vmss1
  vnet_name           = "labvmssup-vnet"
  vnet_resource_group = "labvmssup-vmss1"

  # New resources for the Linux diagnostics VM
  resource_group_name = "labvmssup-vmss1-linux"
  subnet_name         = "linux-subnet"
  subnet_prefix       = "10.101.3.0/24"

  vm_name        = "labvmssup-${local.envId}-linux"
  vm_size        = "Standard_B1s"
  admin_username = "azureuser"

  # Hardcoded password for lab troubleshooting/diagnostics only.
  admin_password = "WelcomeH0me"
}

# Resource group for the Linux diagnostics VM
resource "azurerm_resource_group" "linux" {
  name     = local.resource_group_name
  location = local.location
}

# Reference the EXISTING VNet created by vmss1
data "azurerm_virtual_network" "existing" {
  name                = local.vnet_name
  resource_group_name = local.vnet_resource_group
}

# New subnet inside the existing VNet
resource "azurerm_subnet" "linux" {
  name                 = local.subnet_name
  resource_group_name  = local.vnet_resource_group
  virtual_network_name = data.azurerm_virtual_network.existing.name
  address_prefixes     = [local.subnet_prefix]
}

# Dedicated route table for the Linux subnet (empty for now; modify later)
resource "azurerm_route_table" "linux" {
  name                = "${local.vm_name}-rt"
  location            = local.location
  resource_group_name = azurerm_resource_group.linux.name
}

resource "azurerm_subnet_route_table_association" "linux" {
  subnet_id      = azurerm_subnet.linux.id
  route_table_id = azurerm_route_table.linux.id
}

# Public IP for SSH troubleshooting access
resource "azurerm_public_ip" "linux" {
  name                = "${local.vm_name}-pip"
  location            = local.location
  resource_group_name = azurerm_resource_group.linux.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NSG allowing inbound SSH
resource "azurerm_network_security_group" "linux" {
  name                = "${local.vm_name}-nsg"
  location            = local.location
  resource_group_name = azurerm_resource_group.linux.name

  security_rule {
    name                       = "AllowSSH"
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

resource "azurerm_network_interface" "linux" {
  name                = "${local.vm_name}-nic"
  location            = local.location
  resource_group_name = azurerm_resource_group.linux.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.linux.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux.id
  }
}

resource "azurerm_network_interface_security_group_association" "linux" {
  network_interface_id      = azurerm_network_interface.linux.id
  network_security_group_id = azurerm_network_security_group.linux.id
}

# Minimal Ubuntu LTS VM
resource "azurerm_linux_virtual_machine" "linux" {
  name                            = local.vm_name
  location                        = local.location
  resource_group_name             = azurerm_resource_group.linux.name
  size                            = local.vm_size
  admin_username                  = local.admin_username
  admin_password                  = local.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.linux.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
