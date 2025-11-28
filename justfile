FLAKE := justfile_directory()

# Build Remote Target
nr HOST CONFIG:
    git add .
    nixos-rebuild switch --target-host {{ HOST }} --flake {{ CONFIG }} --sudo --ask-sudo-password

# Build Local
rb CONFIG=(FLAKE):
    git add .
    sudo nixos-rebuild switch --flake {{ CONFIG }}

hm CONFIG=(FLAKE):
    git add .
    home-manager switch --flake {{ CONFIG }}
