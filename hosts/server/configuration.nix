{inputs, pkgs, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko

        # System
        bootloader
        networking
        settings
        user
        disko

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

    services.openssh.enable = true;

    # Any extra Packages
    environment.systemPackages = with pkgs; [];

    system.stateVersion = "24.11"; # Just don't
}
