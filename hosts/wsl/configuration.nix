{inputs, username, ...}:

{
    imports = with inputs.self.nixosModules; [
        inputs.wsl.nixosModules.default {
            system.stateVersion = "25.05";
            wsl.enable = true;
            wsl.defaultUser = username;
        }
        ./hardware-configuration.nix

        # System
        settings
        networking
        user

        # Programs
        neovim
        zsh
    ];

    system.stateVersion = "25.05"; # Just don't

}
