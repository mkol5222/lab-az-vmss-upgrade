locals {
  envId             = var.envId
  rg                = "labvmmsup-management-${local.envId}"
  location          = "westeurope"
  mgmt_name         = "cpman-${local.envId}"
  vnet_name         = "labvmmsup-management-vnet-${local.envId}"
  subnet_name       = "labvmmsup-management-subnet-${local.envId}"
  vnet_address      = "10.0.0.0/16"
  management_subnet = "10.0.1.0/24"
  vm_size           = "Standard_D4ds_v5" //"Standard_D3_v2"
  admin_password    = random_password.admin_password.result
}

