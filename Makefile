
.PHONY: sp-login cpman cpman-ssh

sp-login:
	./scripts/sp-login.sh

cpman:
	(cd cpman && ./up.sh)
cpman-ssh:
	(cd cpman && ./ssh.sh)