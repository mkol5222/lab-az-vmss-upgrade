module "vmss1" {
  source  = "CheckPointSW/cloudguard-network-security/azure//modules/vmss"
  version = "1.2.6"

  # Authentication Variables
  client_secret                   = var.password
  client_id                       = var.appId
  tenant_id                       = var.tenant
  subscription_id                 = var.subscriptionId

  # Basic Configurations Variables
  vmss_name           = "labvmssup-${var.envId}-vmss1"
  resource_group_name = "labvmssup-vmss1"
  location            = "westeurope"
  tags                = {}

  # Virtual Machine Instances Variables
  source_image_vhd_uri           = "noCustomUri"
  authentication_type            = "Password"
  admin_password                 = random_password.admin_password.result
  sic_key                        = "12345678123456"
  serial_console_password_hash   = ""
  maintenance_mode_password_hash = ""
  vm_size                        = "Standard_D4ds_v5"
  disk_size                      = "200"
  os_version                     = "R8120"
  vm_os_sku                      = "sg-byol"
  vm_os_offer                    = "check-point-cg-r8120"
  allow_upload_download          = true
  admin_shell                    = "/bin/bash"
  bootstrap_script               = "touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  availability_zones_num         = "3"
  availability_zones             = ["1", "2", "3"]
  configuration_template_name    = "vmss_template"
  enable_custom_metrics          = true

  # Management Variables
  management_name      = "mgmt"
  management_IP        = "20.123.194.231"
  management_interface = "eth0-public"

  # Networking Variables
  vnet_name                       = "labvmssup-vnet"
  frontend_subnet_name            = "Frontend"
  backend_subnet_name             = "Backend"
  address_space                   = "10.101.0.0/16"
  subnet_prefixes                 = ["10.101.1.0/24", "10.101.2.0/24"]
  nsg_id                          = ""
  storage_account_deployment_mode = "New"
  add_storage_account_ip_rules    = false
  storage_account_additional_ips  = []

  # Load Balancers Variables
  deployment_mode              = "Standard"
  backend_lb_IP_address        = 4
  frontend_load_distribution   = "Default"
  backend_load_distribution    = "Default"
  enable_floating_ip           = true
  use_public_ip_prefix         = false
  create_public_ip_prefix      = false
  existing_public_ip_prefix_id = ""

  # Scale Set variables
  number_of_vm_instances         = 2
  minimum_number_of_vm_instances = 2
  maximum_number_of_vm_instances = 3
  notification_email             = ""
}