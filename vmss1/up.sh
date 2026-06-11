#!/bin/bash

set -euo pipefail

dotenvx run -f ../.env -fk ../.env.keys -- terraform init

dotenvx run -f ../.env -fk ../.env.keys -- terraform apply -auto-approve

# Capture the backend (internal) Load Balancer frontend IP (the NVA address
# that other subnets route through) and persist it to the root .env as
# VMSS1_GW so vmss1-linux can point its default route at it.
dotenvx run -f ../.env -fk ../.env.keys -- bash -c '
  set -euo pipefail
  az account show >/dev/null 2>&1 || \
    az login --service-principal -u "$TF_VAR_appId" -p "$TF_VAR_password" --tenant "$TF_VAR_tenant" -o none
  az account set --subscription "$TF_VAR_subscriptionId"

  VMSS1_GW="$(az network lb list -g labvmssup-vmss1 \
    --query "[].frontendIPConfigurations[?privateIPAddress!=null].privateIPAddress[]" \
    -o tsv | head -n1)"

  if [ -z "$VMSS1_GW" ] || [ "$VMSS1_GW" = "None" ]; then
    echo "Error: could not determine vmss1 backend LB frontend IP." >&2
    exit 1
  fi

  echo "vmss1 backend LB frontend IP (NVA): $VMSS1_GW"
  dotenvx set VMSS1_GW "$VMSS1_GW" -f ../.env
'

