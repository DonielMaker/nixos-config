{pkgs, inputs, username, ...}:

{
    imports = with inputs.self.nixosModules; [
        inputs.wsl.nixosModules.default {
            system.stateVersion = "25.05";
            wsl.enable = true;
            wsl.defaultUser = username;
        }
        ./hardware-configuration.nix

        settings
        networking
        user
        zsh
    ];

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default

        wireguard-tools
    
        typst
        home-manager
    ];

    system.stateVersion = "25.05"; # Just don't

}
