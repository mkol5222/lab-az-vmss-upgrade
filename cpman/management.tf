
module "management" {
  source  = "CheckPointSW/cloudguard-network-security/azure//modules/management"
  version = "~> 1.0"

  # Authentication Variables
  client_secret                   = var.password
  client_id                       = var.appId
  tenant_id                       = var.tenant
  subscription_id                 = var.subscriptionId

  # Basic Configurations Variables
  resource_group_name = local.rg
  mgmt_name           = local.mgmt_name
  location            = local.location
  #tags                = local.tags

  # Virtual Machine Instances Variables
  source_image_vhd_uri           = "noCustomUri"
  authentication_type            = "Password"
  admin_password                 = local.admin_password
  serial_console_password_hash   = ""
  maintenance_mode_password_hash = ""
  vm_size                        = local.vm_size
  disk_size                      = "200"
  os_version                     = "R82"
  vm_os_sku                      = "mgmt-byol"
  vm_os_offer                    = "check-point-cg-r82"
  allow_upload_download          = true
  admin_shell                    = "/bin/bash"
  bootstrap_script               = "clish -s -c 'set timezone Europe / Prague' ; touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  zone                           = ""

  # Networking Variables
  vnet_name                       = local.vnet_name
  subnet_name                     = local.subnet_name
  address_space                   = local.vnet_address
  subnet_prefix                   = local.management_subnet
  management_GUI_client_network   = "0.0.0.0/0"
  mgmt_enable_api                 = "all"
  nsg_id                          = ""
  #storage_account_deployment_mode = var.storage_account_deployment_mode
  #add_storage_account_ip_rules    = var.add_storage_account_ip_rules
  #storage_account_additional_ips  = var.storage_account_additional_ips
}

# module "management" {

#     # source  = "CheckPointSW/cloudguard-network-security/azure//modules/management_new_vnet"
#     # source  = "github.com/mkol5222/terraform-azure-cloudguard-network-security//modules/management_new_vnet?ref=746ef0bcdfd59b779cd098a927410bbf098c1584"
#       source  = "CheckPointSW/cloudguard-network-security/azure//modules/management"
#   version = "~> 1.0"


#     source_image_vhd_uri            = "noCustomUri"
#     resource_group_name             = local.rg
#     mgmt_name                       = local.mgmt_name
#     location                        = local.location
#     vnet_name                       = local.vnet_name
#     address_space                   = local.vnet_address
#     subnet_prefix                   = local.management_subnet
#     management_GUI_client_network   = "0.0.0.0/0"
#     mgmt_enable_api                 = "all"
#     admin_password                  = local.admin_password
#     vm_size                         = local.vm_size
#     disk_size                       = "110"
#     vm_os_sku                       = "mgmt-byol"
#     vm_os_offer                     = "check-point-cg-r82"
#     vm_os_version                   = "8200.900777.2034"
#     os_version                      = "R82"
#     bootstrap_script                = "clish -s -c 'set timezone Europe / Prague' ; touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
#     allow_upload_download           = true
#     authentication_type             = "Password"
#     admin_shell                     = "/bin/bash"
#     serial_console_password_hash    = ""
#     maintenance_mode_password_hash  = ""
#     nsg_id                          = ""
#     add_storage_account_ip_rules    = false
#     storage_account_additional_ips  = []
# }