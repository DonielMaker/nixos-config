FLAKE := justfile_directory()

default:
    just --list

alias rb := rebuild
alias nr := nix-remote
alias ri := remote-install

[doc("Build System Configuration Locally")]
[group("build")]
rebuild CONFIG=(FLAKE) *ARGS:
    @git add .
    sudo nixos-rebuild switch \
        --flake {{ CONFIG }} \
        {{ ARGS }}

[doc("Build System Configuration Remotely")]
[group("build")]
nix-remote HOST CONFIG *ARGS:
    @git add .
    nixos-rebuild switch \
        --target-host {{ HOST }} \
        --flake {{ CONFIG }} \
        --ask-sudo-password \
        {{ ARGS }}

[doc("Install via nixos-anywhere")]
[group("install")]
remote-install HOST CONFIG *ARGS: 
    nix run github:nix-community/nixos-anywhere -- \
            --generate-hardware-config nixos-generate-config "{{ FLAKE }}/hosts/{{ replace(CONFIG, ".#", "") }}/hardware-configuration.nix" \
            --flake {{ CONFIG }} \
            --target-host {{ HOST }} \
            {{ ARGS }}

[doc("Install Nixos locally (Might be Broken rn)")]
[group("install")]
install CONFIG: 
    @git add .
    nix --experimental-features "nix-command flakes" \
        run github:nix-community/disko/latest -- \
        --mode destroy,format,mount "{{ FLAKE }}/hosts/{{ replace(CONFIG, ".#", "")}}/disko.nix"

[doc("Clean Nix-Store")]
[group("maintenance")]
clean:
    sudo nix-collect-garbage -d    
    nix-collect-garbage -d

[doc("Enter a repl with specified flake")]
[group("develop")]
repl CONFIG=(FLAKE):
    nixos-rebuild repl --flake {{ CONFIG }}

gen-auth:
    nix run nixpkgs#authelia -- crypto hash generate argon2 --random
