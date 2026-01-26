# Get the hostname from the system
current_host := `hostname`

test FLAKE=current_host:
    doas nixos apply .#{{FLAKE}} --no-boot

build FLAKE=current_host:
    doas nixos apply .#{{FLAKE}} --no-boot --no-activate --output ./result

rebuild FLAKE=current_host:
    doas nixos apply .#{{FLAKE}}

switch:
    doas nixos generation switch