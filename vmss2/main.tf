# R82 VMSS added to the EXISTING network created by vmss1.
#  - No new VNet is created here (reuses vmss1's "labvmssup-vnet").
#  - No new Load Balancers are created (deployment_mode = "None").
#  - Instances attach to vmss1's existing LB backend pools once known:
#    set frontend_lb_pool_ids / backend_lb_pool_ids below.
#
# Pinned to the commit that adds deployment_mode = "None" + external LB pool
# support (not yet in a tagged release such as v1.2.6).
module "vmss2" {
  #source = "github.com/CheckPointSW/terraform-azure-cloudguard-network-security//modules/vmss?ref=5a2387cc86b4480fb862c79f11e0fd6aec288513"
   source  = "CheckPointSW/cloudguard-network-security/azure//modules/vmss"
  version = "1.2.6"

   
  # Authentication
  client_id       = var.appId
  client_secret   = var.password
  tenant_id       = var.tenant
  subscription_id = var.subscriptionId

  # Basic configuration
  vmss_name           = "labvmssup-${var.envId}-vmss2b"
  resource_group_name = "labvmssup-vmss2"
  location            = "westeurope"

  # R82 image
  os_version  = "R82"
  vm_os_offer = "check-point-cg-r82"
  vm_os_sku   = "sg-byol"
  vm_size     = "Standard_D4ds_v5"
  disk_size   = "200"

  # Access & bootstrap
  authentication_type   = "Password"
  admin_password        = random_password.admin_password.result
  admin_shell           = "/bin/bash"
  allow_upload_download = true
  sic_key               = "12345678123456"

  # CME management (same management server as vmss1)
  management_name             = "mgmt"
  management_IP               = "20.123.194.231"
  management_interface        = "eth0-public"
  configuration_template_name = "labvmssup_r82_template"

  # Reuse the EXISTING network created by vmss1
  vnet_name                    = "labvmssup-vnet"
  existing_vnet_resource_group = "labvmssup-vmss1"
  address_space                = "" # empty => use the existing VNet
  frontend_subnet_name         = "Frontend"
  backend_subnet_name          = "Backend"

    # One new backend Load Balancer is created.
  deployment_mode              = "Standard" # "Standard" creates new LB, "None" reuses existing LB (must set LB pool IDs below)
  backend_lb_IP_address        = 90
  #frontend_lb_pool_ids         = []
  frontend_load_distribution   = "Default"
  # backend_lb_pool_ids  = []
  backend_load_distribution    = "Default"

  # Scale set
  number_of_vm_instances         = 2
  minimum_number_of_vm_instances = 2
  maximum_number_of_vm_instances = 3
  availability_zones_num         = "3"
  availability_zones             = ["1", "2", "3"]
}
