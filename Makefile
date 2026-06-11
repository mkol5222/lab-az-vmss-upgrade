
.PHONY: sp-login cpman

sp-login:
	./scripts/sp-login.sh

cpman:
	(cd cpman && ./up.sh)