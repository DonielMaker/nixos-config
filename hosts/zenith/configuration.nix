{inputs, pkgs, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko

        # System
        settings
        networking
        bootloader
        disko
        user

        # Programs
        neovim
        steam
        zsh

        # Modules
        sound
        graphics
        openrgb
        # sddm
        gdm
        amd
    ];

    environment.systemPackages = with pkgs; [
        firefox
        qt6ct
        freecad
        # Gaming
        protonup-qt
        lutris
        prismlauncher
        steam
        everest-mons

        # Programs
        vesktop
        nemo
        hyprpicker
        geeqie
        (flameshot.override { enableWlrSupport = true; })
        # Other
        alsa-scarlett-gui
        home-manager
    ];

    # Steam drive
    fileSystems."/home/donielmaker/Games" = {
        device = "/dev/nvme0n1p1";
        fsType = "ext4";
        options = [ "users" "nofail" "exec" ];
    };

    system.stateVersion = "24.11"; # Just don't
}
