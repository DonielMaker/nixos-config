{config, inputs, pkgs, pkgs-stable, ...}:

{
    imports = [ ./hardware-configuration.nix ./disko.nix ];

    modules = {
        system = {
            enable = true;
            hostname = "zenith";
            username = "donielmaker";
            shell = pkgs.zsh;

            user.enable = true;
            
            limine.enable = true;
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
            graphics.enable = true;
            gigabyte.enable = true;
            sound.enable = true;
            networking.enable = true;
            bluetooth.enable = true;

            stylix.enable = true;

            hyprland.enable = true;
            dms.enable = true;
        };

        programs = {
            steam.enable = true;
            coolercontrol.enable = true;
            zsh.enable = true;
        };
    };

    networking.nameservers = [ "10.10.12.10" "10.10.110.10" "1.1.1.1" ];
    networking.search = [ "thematt.net, soluttech.uk" ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;

    services.flatpak.enable = true;

    security.pam.services.${config.modules.system.username}.kwallet.enable = true;

    services.lact.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

        scarlett2
        alsa-scarlett-gui

        brave 
        geeqie
        gimp
        pkgs-stable.kdePackages.kdenlive
        vesktop
        obs-studio
        orca-slicer
        drawio

        prismlauncher
        heroic
        steam
        everest-mons
        xclicker
        owmods-gui
        owmods-cli
        protonplus
        olympus

        kdePackages.kwallet

        element-desktop
        teamspeak6-client

        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}
