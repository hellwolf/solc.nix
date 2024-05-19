lint:
	nix-shell -p nixfmt-rfc-style --run \
		"nixfmt -c default.nix flake.nix mk-solc-pkgs.nix mk-solc-static.nix"

flake-check:
	nix flake check --print-build-logs --show-trace --no-build --debug --verbose --all-systems

.PHONY: lint flake-*
