lint:
	nix-shell -p nixfmt-rfc-style --run \
		"nixfmt -c default.nix flake.nix mk-solc-pkgs.nix mk-solc-static-pkg.nix"

flake-check:
	nix flake check --print-build-logs --show-trace --no-build --all-systems

.PHONY: lint flake-*

