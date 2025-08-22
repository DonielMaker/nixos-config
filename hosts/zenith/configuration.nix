{ inputs, pkgs, pkgs-stable, system, config, myLib, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default

        limine
        networking
        settings
        user

        graphics
        amd

        regreet

        sound
        gigabyte
        coolercontrol

        neovim
        steam
        zsh
    ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_15;

    services.flatpak.enable = true;

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "kitty";

    networking.search = [ "thematt.net" ];

    # programs.localsend.enable = true;

    networking.wg-quick.interfaces.wg0 = {
        address = [ "10.10.14.7/24" ];
        dns = [ "1.1.1.1" ];
        peers = [
        {
            allowedIPs = [
                "10.10.14.0/24"
                "10.10.12.0/24"
            ];
            endpoint = "public.ipv64.de:51820";
            publicKey = "Ltmlc2mcJuKprhi5l6rU2hwMqejwQIQ/GFZB+sEckCQ=";
            presharedKeyFile = config.age.secrets.wireguard-shrKey.path;
        }
        ];
        privateKeyFile = config.age.secrets.wireguard-priKey.path;
    };

    services.lact.enable = true;

    services.openssh.enable = true;

    age.secrets = myLib.getSecrets ./secrets;

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default
        inputs.quickshell.packages.${system}.quickshell

        # geekbench_6
        signal-desktop
        upscaler
        obs-studio
        hyprpolkitagent

        # Gaming
        # xclicker
        protonup-qt
        lutris
        pkgs-stable.prismlauncher
        steam
        everest-mons

        # Programs
        ferrishot
        lm_sensors
        # gimp
        vlc
        kdePackages.kdenlive
        orca-slicer
        bambu-studio
        qt6ct
        vesktop
        nautilus
        hyprpicker
        geeqie
        alsa-scarlett-gui
        # Other
        xdg-desktop-portal
        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}
