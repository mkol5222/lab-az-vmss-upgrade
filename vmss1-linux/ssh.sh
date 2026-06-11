#!/bin/bash

set -euo pipefail

# if ~/.ssh/id_rsa.pub does not exist, create key without passphrase
if [ ! -f ~/.ssh/id_rsa.pub ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi

ADMIN_USERNAME="azureuser"
ADMIN_PASSWORD="WelcomeH0me"

LINUX_IP=$(terraform output -raw linux_public_ip)

cat <<EOF

vmss1-linux diagnostics VM:

Admin Username:   $ADMIN_USERNAME
Admin Password:   $ADMIN_PASSWORD
Public IP:        $LINUX_IP

EOF

sshpass -p "$ADMIN_PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no "$ADMIN_USERNAME"@"$LINUX_IP"

ssh "$ADMIN_USERNAME"@"$LINUX_IP" "$@"
