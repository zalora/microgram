export NIX_PATH = $(PWD)/deps
SHELL = bash -e -o pipefail

.PHONY: deps
deps:
	nix-instantiate --eval --strict --json -A get-deps deps.nix \
		| jq -r '.[]' \
		| $(SHELL)
