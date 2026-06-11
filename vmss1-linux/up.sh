#!/bin/bash

set -euo pipefail

dotenvx run -f ../.env -fk ../.env.keys -- terraform init

# Map the NVA gateway IPs saved by vmss1/up.sh and vmss2/up.sh (VMSS1_GW /
# VMSS2_GW in the root .env) onto the Terraform vmss1_gw / vmss2_gw variables.
dotenvx run -f ../.env -fk ../.env.keys -- bash -c '
  set -euo pipefail
  export TF_VAR_vmss1_gw="${VMSS1_GW:-}"
  export TF_VAR_vmss2_gw="${VMSS2_GW:-}"
  terraform apply -auto-approve
'

