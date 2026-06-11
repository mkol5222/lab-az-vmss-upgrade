
locals {
  layer_name = "${checkpoint_management_package.vmss.name} Network"
}

data "checkpoint_management_data_access_rule" "data_access_rule" {
  depends_on = [checkpoint_management_package.vmss]
  name       = "Cleanup rule"
  layer      = local.layer_name
}

####
#
# Cleanup section 
resource "checkpoint_management_access_section" "cleanup_section" {
  name  = "Cleanup"
  layer = local.layer_name

  position {
    above = data.checkpoint_management_data_access_rule.data_access_rule.name
  }
}

####
#
# Allow net10 to any
resource "checkpoint_management_access_rule" "net10_to_any" {
  name        = "net10 to any"
  layer       = local.layer_name
  source      = [checkpoint_management_network.net10.name]
  destination = ["Any"]
  service     = ["Any"]
  action      = "Accept"

  track {
    type           = "Log"
    per_connection = true
  }

  position {
    above = checkpoint_management_access_section.cleanup_section.name
  }
}