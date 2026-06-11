variable "envId" {
  description = "Environment ID"
  type        = string
}

variable "tenant" {
  description = "Azure Tenant ID"
  type        = string
}

variable "subscriptionId" {
  description = "Azure Subscription ID"
  type        = string
}

variable "appId" {
  description = "Azure Service Principal App ID"
  type        = string
}

variable "password" {
  description = "Azure Service Principal Password"
  type        = string
}

variable "gw" {
  description = "Default gateway for the Linux subnet: 'Internet' (direct egress), 'vmss1' or 'vmss2' (route 0.0.0.0/0 through the corresponding VMSS backend LB frontend IP / NVA)."
  type        = string
  default     = "Internet"

  validation {
    condition     = contains(["Internet", "vmss1", "vmss2"], var.gw)
    error_message = "gw must be one of: Internet, vmss1, vmss2."
  }
}

variable "vmss1_gw" {
  description = "vmss1 backend LB frontend (NVA) IP. Populated from VMSS1_GW in the root .env via up.sh."
  type        = string
  default     = ""
}

variable "vmss2_gw" {
  description = "vmss2 backend LB frontend (NVA) IP. Populated from VMSS2_GW in the root .env via up.sh."
  type        = string
  default     = ""
}
