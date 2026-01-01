FLAKE := justfile_directory()

default:
    just --list

# Build System Configuration
rb CONFIG=(FLAKE):
    git add .
    sudo nixos-rebuild switch --flake {{ CONFIG }}

# Build Home Configuration
hm CONFIG=(FLAKE):
    git add .
    home-manager switch --flake {{ CONFIG }}

# Build Remote Target
nr HOST CONFIG:
    git add .
    nixos-rebuild switch --target-host {{ HOST }} --flake {{ CONFIG }} --sudo --ask-sudo-password

# Generates the plaintext and hashed secrets for OIDC Clients
gen-auth:
    nix run nixpkgs\#authelia -- crypto hash generate argon2 --random --random.length 64 --random.charset alphanumeric

# Update the flake and rb/hm
update:
    nix flake update
    just rb
    just hm

# Clean Nix-Store
clean:
    sudo nix-collect-garbage -d    
    nix-collect-garbage -d

repl CONFIG=(FLAKE):
    nixos-rebuild repl --flake {{ CONFIG }}
