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

# Execute rb and hm afterwards
update:
    just rb
    just hm

# Update nix flake and run just update
update-full:
    nix flake update
    just update

# Clean Nix-Store
clean:
    sudo nix-collect-garbage -d    
    nix-collect-garbage -d

# Run a nixosConfiguration inside a repl
repl CONFIG=(FLAKE):
    nixos-rebuild repl --flake {{ CONFIG }}

[doc("""
Install via nixos-anywhere
    HARDWARE_PATH: path to your hardware-configuration.nix
    HOST: host to install the config on (user@ip_address)
    CONFIG: path to flake
""")]
remote-install HARDWARE_PATH HOST CONFIG: 
    nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config {{ HARDWARE_PATH }} --flake {{ CONFIG }} --target-host {{ HOST }}
