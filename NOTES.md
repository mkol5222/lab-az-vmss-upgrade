
# test1

```shell
# managemebt already exists, so just start it
make cpman-start
# createv environment
make vmss1
make vmss2
make vmss1-linux
```

point Linux to vmss1, make traffic and check FW logs

```shell
(cd vmss1-linux && TF_VAR_gw=vmss1 ./up.sh)
(cd vmss1-linux && ./ssh.sh)
# while true; do curl -m1 ifconfig.me; sleep 1; echo; done

(cd vmss1-linux && TF_VAR_gw=vmss2 ./up.sh)
(cd vmss1-linux && ./ssh.sh)
# while true; do curl -m1 ifconfig.me; sleep 1; echo; done

# destroy resources from VMSS1 and check that traffic is still flowing through VMSS2
cd vmss1

# dry run
dotenvx run -f ../.env -fk ../.env.keys -- terraform plan -destroy \
  -target='module.example_module.azurerm_monitor_autoscale_setting.vmss_settings' \
  -target='module.example_module.azurerm_linux_virtual_machine_scale_set.vmss' \
  -target='module.example_module.azurerm_lb_rule.lbnatrule_standard' \
  -target='module.example_module.azurerm_lb_probe.azure_lb_healprob' \
  -target='module.example_module.azurerm_lb_backend_address_pool.backend_lb_pool' \
  -target='module.example_module.azurerm_lb_backend_address_pool.frontend_lb_pool' \
  -target='module.example_module.azurerm_lb.frontend_lb' \
  -target='module.example_module.azurerm_lb.backend_lb' \
  -target='module.example_module.azurerm_public_ip.public_ip_lb' \
  -target='module.example_module.azurerm_role_assignment.custom_metrics_role_assignment' \
  -target='module.example_module.module.vm_boot_diagnostics_storage.azurerm_storage_account.vm_boot_diagnostics_storage'

# for real
dotenvx run -f ../.env -fk ../.env.keys -- terraform destroy \
  -target='module.example_module.azurerm_monitor_autoscale_setting.vmss_settings' \
  -target='module.example_module.azurerm_linux_virtual_machine_scale_set.vmss' \
  -target='module.example_module.azurerm_lb_rule.lbnatrule_standard' \
  -target='module.example_module.azurerm_lb_probe.azure_lb_healprob' \
  -target='module.example_module.azurerm_lb_backend_address_pool.backend_lb_pool' \
  -target='module.example_module.azurerm_lb_backend_address_pool.frontend_lb_pool' \
  -target='module.example_module.azurerm_lb.frontend_lb' \
  -target='module.example_module.azurerm_lb.backend_lb' \
  -target='module.example_module.azurerm_public_ip.public_ip_lb' \
  -target='module.example_module.azurerm_role_assignment.custom_metrics_role_assignment' \
  -target='module.example_module.module.vm_boot_diagnostics_storage.azurerm_storage_account.vm_boot_diagnostics_storage'


```