{ inputs, pkgs, ... }:

{
    imports = [ ./hardware-configuration.nix ./disko.nix ];

    networking.hostName = "zenith";

    services.xserver.xkb.layout = "us";

    settings = {
        username = "donielmaker";
        mail = "daniel.schmidt0204@gmail.com";
    };

    modules = {
        system = {
            enable = true;

            user.enable = true;
            
            limine.enable = true;
            limine.resolution = "2560x1440";
            limine.image = pkgs.fetchurl {
                url = "https://codeberg.org/solut/pub_ressources/raw/branch/main/images/wallpaper/vladislav-klapin-o-SMjjGuP6c-unsplash.jpg";
                sha256 = "sha256-+ObY8Jft/Ergnufgcp/cXKV/webd+74yl1XdsCYdMp0=";
            };

            openssh.enable = true;
        };

        hm.enable = true;
        hm.home = ./home.nix;

        desktop = {
            enable = true;
            bluetooth.enable = true;
            gigabyte.enable = true;
            sound.enable = true;

            hyprland.enable = true;
            noctalia.enable = true;
            stylix.enable = true;
        };

        programs = {
            coolercontrol.enable = true;
            librewolf.enable = true;
            obsidian.enable = true;
            steam.enable = true;
            vesktop.enable = true;
            virt-manager.enable = true;
            webdav.enable = true;
            woeusb.enable = true;
        };

        terminal = {
            alacritty.enable = true;
            git.enable = true;
            neovim.enable = true;
            starship.enable = true;
            zsh.enable = true;
        };
    };

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_2;

    services.flatpak.enable = true;

    # Gpu Overclocking
    services.lact.enable = true;

    # services.ollama.enable = true;
    # services.ollama = {
    #     package = pkgs.ollama-rocm;
    # };

    # INFO: Note that you have to set nixpkgs.config.rocmSupport = true; for AMD
    # users.users.comfyui.extraGroups = [ "video" "render" ];
    # services.comfyui.enable = true;
    # services.comfyui.extraArgs = [ "--lowvram" ];

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

        # == Programs ==
        gimp # Image editing
        obs-studio # Video Recording
        orca-slicer # 3D Printer Slicer
        kdePackages.kdenlive # Video editing
        zathura # PDF Viewer

        element-desktop # Matrix client
        # teamspeak6-client # Teamspeak client

        # == Utils ==
        ansible # IaC
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
