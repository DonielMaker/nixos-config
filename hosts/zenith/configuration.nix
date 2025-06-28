{ inputs, pkgs, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko
        inputs.stylix.nixosModules.stylix

        # stylix

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
        # cosmic-greeter
        regreet
            # gdm
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

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_14;

    services.flatpak.enable = true;

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "kitty";

    networking.search = [ "thematt.net" ];

    # programs.localsend.enable = true;

    # networking.wg-quick.interfaces.wg0 = {
    #     address = [ "10.10.14.7/24" ];
    #     dns = [ "1.1.1.1" ];
    #     peers = [
    #     {
    #         allowedIPs = [
    #             "10.10.14.0/24"
    #         ];
    #         endpoint = "public.ipv64.de:51820";
    #         publicKey = "Ltmlc2mcJuKprhi5l6rU2hwMqejwQIQ/GFZB+sEckCQ=";
    #         presharedKey = "MIWvpJMPF0Q4m6OkqImXVgqDZOXKbOvoreUrIVl83Mw=";
    #     }
    #     ];
    #     privateKey = "8Jqb5G7dp9U/ObycGM3/voh0y4FSSgadBs6pOfeoN2Q=";
    # };

    services.lact.enable = true;

    environment.systemPackages = with pkgs; [
        geekbench_6
        upscaler
        obs-studio
        hyprpolkitagent

        # Gaming
        xclicker
        protonup-qt
        lutris
        prismlauncher
        steam
        everest-mons

        # Programs
        ferrishot
        lm_sensors
        gimp
        vlc
        kdePackages.kdenlive
        orca-slicer
        qt6ct
        vesktop
        nautilus
        hyprpicker
        geeqie
        alsa-scarlett-gui
        # Other
        xdg-desktop-portal
        papirus-icon-theme
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
