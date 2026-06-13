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
            limine.resolution = "2560x1440";
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
            virt-manager.enable = true;
        };

        terminal = {
            neovim.enable = true;
            zsh.enable = true;
        };

        server.podman.enable = true;
    };

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_0;

    services.flatpak.enable = true;

    services.netbird.enable = true;

    # Display Manager
    services.displayManager.ly.enable = true;

    # Gpu Overclocking
    services.lact.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

        # == Programs ==
        freecad # CAD Software
        gimp # Image editing
        obs-studio # Video Recording
        orca-slicer # 3D-Printer Slicer
        pkgs-stable.kdePackages.kdenlive # Video editing
        zathura # PDF Viewer

        element-desktop # Matrix client
        # teamspeak6-client # Teamspeak client

        # == Utils ==
        cryptsetup # Encrypted Drives
        furmark # Gpu Stress Testing
        stress-ng # General Stress Testing
        typst # Professional Documents
        wireguard-tools # Wireguard related commands

        # == Gaming ==
        heroic # Epic Games Launcher
        olympus # Celeste Mod Manager
        owmods-gui # Outer Wilds Mod Manager
        prismlauncher # Minecraft Launcher
        protonplus # Manage Valve's Proton
        r2modman # General Mod Manager
        steam # Steam
        xclicker # Autoclicker

        # == Audio ==
        alsa-scarlett-gui # Manage Scarlett Routing
        scarlett2 # Manage Scarlett Firmware
    ];

    system.stateVersion = "24.11"; # Just don't
}
