{config, inputs, pkgs, pkgs-stable, ...}:

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
            graphics.enable = true;
            gigabyte.enable = true;
            sound.enable = true;
            bluetooth.enable = true;

            stylix.enable = true;

            noctalia.enable = true;
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
            librewolf.enable = true;
            obsidian.enable = true;
        };

        terminal = {
            alacritty.enable = true;
            git.enable = true;
            neovim.enable = true;
            starship.enable = true;
            zellij.enable = true;
            zsh.enable = true;
        };
    };

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_0;

    services.flatpak.enable = true;

    security.pam.services.${config.modules.system.username}.kwallet.enable = true;

    services.lact.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

        scarlett2
        alsa-scarlett-gui

        brave 
        gimp
        pkgs-stable.kdePackages.kdenlive
        vesktop
        obs-studio
        orca-slicer
        typst
        freecad

        prismlauncher
        heroic
        steam
        xclicker
        owmods-gui
        owmods-cli
        protonplus
        olympus
        r2modman

        kdePackages.kwallet
        kdePackages.kate

        element-desktop
        gajim
        teamspeak6-client

        home-manager
    ];

    fonts.packages = with pkgs; [
        aileron
    ];

    system.stateVersion = "24.11"; # Just don't
}
