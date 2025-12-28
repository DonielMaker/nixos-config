FLAKE := justfile_directory()

default:
    just --list

# Build Remote Target
nr HOST CONFIG:
    git add .
    nixos-rebuild switch --target-host {{ HOST }} --flake {{ CONFIG }} --sudo --ask-sudo-password

# Build System Configuration
rb CONFIG=(FLAKE):
    git add .
    sudo nixos-rebuild switch --flake {{ CONFIG }}

# Build Home Configuration
hm CONFIG=(FLAKE):
    git add .
    home-manager switch --flake {{ CONFIG }}

# Generates the plaintext and hashed secrets for OIDC Clients
gen-auth:
    nix run nixpkgs\#authelia -- crypto hash generate argon2 --random --random.length 64 --random.charset alphanumeric
