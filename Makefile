
.PHONY: sp-login cpman cpman-ssh linux vmss1 vmss2

sp-login:
	./scripts/sp-login.sh

cpman:
	(cd cpman && ./up.sh)
cpman-ssh:
	(cd cpman && ./ssh.sh)
cpman-start:
	(cd cpman && ./startvm.sh)
cpman-stop:
	(cd cpman && ./stopvm.sh)

linux:
	(cd vmss1-linux && ./up.sh)
vmss1-linux: linux
vmss1:
	(cd vmss1 && ./up.sh)
vmss2:
	(cd vmss2 && ./up.sh)

linux-down:
	(cd vmss1-linux && ./down.sh)
vmss1-down:
	(cd vmss1 && ./down.sh)
vmss2-down:
	(cd vmss2 && ./down.sh)

linux-ssh:
	(cd vmss1-linux && ./ssh.sh)