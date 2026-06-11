####
#
# VMSS NAT section
resource "checkpoint_management_nat_section" "vmss_nat" {
  name    = "VMSS NAT"
  package = checkpoint_management_package.vmss.name

  position {
    bottom = "bottom"
  }
}

####
#
# No NAT for net10 to net10 (keep original source)
resource "checkpoint_management_nat_rule" "net10_no_nat" {
  package = checkpoint_management_package.vmss.name
  name    = "net10 to net10 - No NAT"
  enabled = true
  method  = "static"

  original_source        = checkpoint_management_network.net10.name
  original_destination   = checkpoint_management_network.net10.name
  original_service       = "Any"
  translated_source      = "Original"
  translated_destination = "Original"
  translated_service     = "Original"

  position {
    below = checkpoint_management_nat_section.vmss_nat.name
  }
}

####
#
# Hide NAT net10 behind LocalGatewayExternal
resource "checkpoint_management_nat_rule" "net10_hide" {
  package = checkpoint_management_package.vmss.name
  name    = "net10 - Hide behind LocalGatewayExternal"
  enabled = true
  method  = "hide"

  original_source   = checkpoint_management_network.net10.name
  translated_source = "LocalGatewayExternal"

  position {
    below = checkpoint_management_nat_rule.net10_no_nat.name
  }
}

