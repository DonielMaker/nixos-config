{inputs, pkgs, pkgs-stable, ...}:

{
    imports = [ ./hardware-configuration.nix ./disko.nix ];

    modules = {
        system = {
            enable = true;
            hostname = "zenith";
            username = "donielmaker";
            mail = "daniel.schmidt0204@gmail.com";
            shell = pkgs.zsh;

            user.enable = true;
            
            limine.enable = true;
            limine.image = pkgs.fetchurl {
                url = "https://codeberg.org/solut/pub_ressources/raw/branch/main/images/wallpaper/vladislav-klapin-o-SMjjGuP6c-unsplash.jpg";
                sha256 = "sha256-+ObY8Jft/Ergnufgcp/cXKV/webd+74yl1XdsCYdMp0=";
            };

            openssh.enable = true;
            networking.enable = true;
        };

        hm.enable = true;
        hm.home = ./home.nix;

        desktop = {
            enable = true;
            gigabyte.enable = true;
            sound.enable = true;
            bluetooth.enable = true;

            stylix.enable = true;
            hyprland.enable = true;
            hyprland.monitor = [
                "DP-1, 2560x1440@144hz, auto, 1"
                "DP-2, 1920x1080@180hz, auto-left, 1, transform, 3"
            ];
        };

        programs = {
            steam.enable = true;
            coolercontrol.enable = true;
            webdav.enable = true;
        };

        terminal = {
            neovim.enable = true;
            zsh.enable = true;
        };
    };

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_0;

    services.flatpak.enable = true;

    # Display Manager
    services.displayManager.ly.enable = true;

    # Gpu Overclocking
    services.lact.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

        # == Programs ==
        gimp # Image editing
        pkgs-stable.kdePackages.kdenlive # Video editing
        obs-studio # Video Recording
        orca-slicer # 3D-Printer Slicer
        freecad # CAD Software

        element-desktop # Matrix client
        teamspeak6-client # Teamspeak client

        # == Utils ==
        typst # Professional Documents
        cryptsetup # Encrypted Drives

        # == Gaming ==
        prismlauncher # Minecraft Launcher
        heroic # Epic Games Launcher
        steam # Steam
        owmods-gui # Outer Wilds Mod Manager
        olympus # Celeste Mod Manager
        r2modman # General Mod Manager
        protonplus # Manage Valve's Proton
        xclicker # Autoclicker (Don't know how good it works with wayland)

        scarlett2 # Manage Scarlett Firmware
        alsa-scarlett-gui # Manage Scarlett Routing
    ];

    # This might have to be moved to stylix or similar
    fonts.packages = with pkgs; [ aileron ];

    system.stateVersion = "24.11"; # Just don't
}
