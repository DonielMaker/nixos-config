{inputs, pkgs, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        # inputs.disko.nixosModules.disko

        # System
        bootloader
        networking
        settings
        user
        # disko

        # Hyprland (and other graphics related stuff)
            # graphics

        # Graphics driver
            # intel
            # nvidia
            # amd

        # Display manager
            # gdm
            # sddm

        # Hardware related
            # bluethooth
            # fingerprint
            # sound

        # Programs 
            # neovim
            # openrgb
            # steam
            # zsh
    ];

    # Any extra Packages
    environment.systemPackages = with pkgs; [];

    system.stateVersion = throw "system.stateVersion not configured"; # Just don't
}
