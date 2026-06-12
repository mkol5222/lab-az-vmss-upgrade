
# test1

```shell
# managemebt already exists, so just start it
make cpman-start
# createv environment
make vmss1
make vmss1-linux
(cd vmss1-linux && TF_VAR_gw=vmss1 ./up.sh)
make vmss2

```

point Linux to vmss1, make traffic and check FW logs

```shell
(cd vmss1-linux && TF_VAR_gw=vmss1 ./up.sh)
(cd vmss1-linux && ./ssh.sh)
# while true; do curl -m1 ifconfig.me; sleep 1; echo; done
```

point Linux to vmss2, make traffic and check FW logs

```shell
(cd vmss1-linux && TF_VAR_gw=vmss2 ./up.sh)
(cd vmss1-linux && ./ssh.sh)
# while true; do curl -m1 ifconfig.me; sleep 1; echo; done
```

check inventory of VMSS1

```shell
# destroy resources from VMSS1 and check that traffic is still flowing through VMSS2
az vmss list      -g labvmssup-vmss1 -o table   
az network lb list -g labvmssup-vmss1 -o table  
```

now we can release VMSS1 resources from Azure

```shell
# dry run
cd vmss1
dotenvx run -f ../.env -fk ../.env.keys -- terraform plan -destroy \
  -target='module.vmss1.azurerm_monitor_autoscale_setting.vmss_settings' \
  -target='module.vmss1.azurerm_linux_virtual_machine_scale_set.vmss' \
  -target='module.vmss1.azurerm_lb_rule.lbnatrule_standard' \
  -target='module.vmss1.azurerm_lb_probe.azure_lb_healprob' \
  -target='module.vmss1.azurerm_lb_backend_address_pool.backend_lb_pool' \
  -target='module.vmss1.azurerm_lb_backend_address_pool.frontend_lb_pool' \
  -target='module.vmss1.azurerm_lb.frontend_lb' \
  -target='module.vmss1.azurerm_lb.backend_lb' \
  -target='module.vmss1.azurerm_public_ip.public_ip_lb' \
  -target='module.vmss1.azurerm_role_assignment.custom_metrics_role_assignment' \
  -target='module.vmss1.module.vm_boot_diagnostics_storage.azurerm_storage_account.vm_boot_diagnostics_storage'

# for real
cd vmss1
dotenvx run -f ../.env -fk ../.env.keys -- terraform destroy \
  -target='module.vmss1.azurerm_monitor_autoscale_setting.vmss_settings' \
  -target='module.vmss1.azurerm_linux_virtual_machine_scale_set.vmss' \
  -target='module.vmss1.azurerm_lb_rule.lbnatrule_standard' \
  -target='module.vmss1.azurerm_lb_probe.azure_lb_healprob' \
  -target='module.vmss1.azurerm_lb_backend_address_pool.backend_lb_pool' \
  -target='module.vmss1.azurerm_lb_backend_address_pool.frontend_lb_pool' \
  -target='module.vmss1.azurerm_lb.frontend_lb' \
  -target='module.vmss1.azurerm_lb.backend_lb' \
  -target='module.vmss1.azurerm_public_ip.public_ip_lb' \
  -target='module.vmss1.azurerm_role_assignment.custom_metrics_role_assignment' \
  -target='module.vmss1.module.vm_boot_diagnostics_storage.azurerm_storage_account.vm_boot_diagnostics_storage'

# check azure
# vmss1 compute/LB should be gone:
az vmss list      -g labvmssup-vmss1 -o table   # expect empty
az network lb list -g labvmssup-vmss1 -o table   # expect empty

# network layer must still exist:
az network vnet show   -g labvmssup-vmss1 -n labvmssup-vnet -o table
az network vnet subnet list -g labvmssup-vmss1 --vnet-name labvmssup-vnet --query "[].{name:name,nsg:networkSecurityGroup.id,rt:routeTable.id}" -o table

# vmss2 + linux still healthy, and vmss2 config is stable:
az vmss list -g labvmssup-vmss2 -o table

# vmss2 not touched - no changes expected (might show unrelated changes cause by tags):
(cd ../vmss2 && dotenvx run -f ../.env -fk ../.env.keys -- terraform plan)   # expect: no changes
```

in case we want VMSS1 back
# 20.56.23.154
# 20.86.42.155

```shell
# put VMSS1 back; bacause removed resources are not commented out, just re-apply
make vmss1
```

removing it all, but mamagement

```shell
# destroy
make linux-down
make vmss2-down
make vmss1-down

```