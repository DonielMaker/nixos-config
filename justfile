default:
    just --list

alias rb := rebuild
alias nr := nix-remote
alias ri := remote-install

[doc("Build System Configuration locally")]
[group("build")]
rebuild MODE="switch":
    @git add .
    sudo nixos-rebuild {{ MODE }} --flake .

[doc("Build System Configuration Remotely")]
[group("build")]
nix-remote HOST CONFIG MODE="switch":
    @git add .
    nixos-rebuild {{ MODE }} \
        --flake {{ CONFIG }} \
        --target-host {{ HOST }} \
        --ask-sudo-password \

[doc("Install via nixos-anywhere")]
[group("install")]
remote-install HOST CONFIG: 
    @git add .
    nix run github:nix-community/nixos-anywhere -- \
            --generate-hardware-config nixos-generate-config "./hosts/{{ replace(CONFIG, ".#", "") }}/hardware-configuration.nix" \
            --flake {{ CONFIG }} \
            --target-host {{ HOST }}

[doc("Enter a repl with specified flake")]
[group("develop")]
repl CONFIG:
    nixos-rebuild repl --flake {{ CONFIG }}

[doc("Install Disko (Might be Broken rn)")]
[group("install")]
install CONFIG: 
    @git add .
    nix --experimental-features "nix-command flakes" \
        run github:nix-community/disko/latest -- \
        --mode destroy,format,mount "./hosts/{{ replace(CONFIG, ".#", "")}}/disko.nix"

