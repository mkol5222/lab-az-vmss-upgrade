resource "checkpoint_management_network" "net10" {
  name  = "net10"
  color = "blue"

  subnet4      = "10.0.0.0"
  mask_length4 = 8
}