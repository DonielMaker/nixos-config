{config, inputs, pkgs, pkgs-stable, ...}:

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
        graphics

        # Graphics driver
            # intel
            # nvidia
        amd

        # Display manager
        gdm
            # sddm

        # Hardware related
            # bluethooth
            # fingerprint
        sound
        gigabyte
        coolercontrol

        # Programs 
        neovim
        # openrgb
        steam
        zsh
    ];

    environment.systemPackages = with pkgs; [
        papirus-icon-theme
        lm_sensors
        # Gaming
        xclicker
        protonup-qt
        lutris
        prismlauncher
        steam
        everest-mons

        # Programs
        gimp
        vlc
        kdePackages.kdenlive
        orca-slicer
        qt6ct
        vesktop
        nemo
        hyprpicker
        geeqie
        # Other
        alsa-scarlett-gui
        home-manager
    ];

    # Steam drive
    fileSystems."/home/donielmaker/Games" = {
        device = "/dev/disk/by-uuid/97b08468-250f-483a-96db-bf1be07dca05";
        fsType = "ext4";
        options = [ "users" "nofail" "exec" ];
    };

    system.stateVersion = "24.11"; # Just don't
}
