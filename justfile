# Maybe fix this?
FLAKE := "/home/donielmaker/.config/nix"

nr HOST CONFIG:
    nixos-rebuild switch --target-host {{ HOST }} --flake {{ CONFIG }} --sudo --ask-sudo-password

rb CONFIG="":
    sudo nixos-rebuild switch --flake {{ if CONFIG != "" { CONFIG } else { FLAKE } }}
