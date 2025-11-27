# Maybe fix this?
FLAKE := "/home/donielmaker/.config/nix"

nr HOST CONFIG:
    git add .
    nixos-rebuild switch --target-host {{ HOST }} --flake {{ CONFIG }} --sudo --ask-sudo-password

rb CONFIG="":
    git add .
    sudo nixos-rebuild switch --flake {{ if CONFIG != "" { CONFIG } else { FLAKE } }}
