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
