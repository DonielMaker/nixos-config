{ system, inputs, pkgs, ...}:

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
        cosmic-greeter
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

    services.flatpak.enable = true;

    programs.corectrl.enable = true;
    programs.corectrl.gpuOverclock.enable = true;
    programs.corectrl.gpuOverclock.ppfeaturemask = "0xffffffff";
    security.polkit.enable = true;

    # networking.wg-quick.interfaces.wg0 = {
    #     address = [ "10.8.0.3/24" ];
    #     dns = [ "192.168.178.3" ];
    #     peers = [
    #     {
    #         allowedIPs = [
    #             "192.168.178.0/24"
    #         ];
    #         endpoint = "famuv.duckdns.org:51820";
    #         publicKey = "kkfeCXjQLQqNRw7QOeLwzDDySTwrPyDOXWiHZaiFcD4=";
    #         presharedKey = "QsWoEB4sRIRfuoM706OFHE9UHV8+LKzSYmF5WboIkhQ=";
    #     }
    #     ];
    #     privateKey = "0J2cBDUGEVGEM73uFArgfK4LhkuSTrmxCJwaaEzgskM=";
    # };

    environment.systemPackages = with pkgs; [
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
