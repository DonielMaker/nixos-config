{inputs, config, pkgs, system, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default
        inputs.stylix.nixosModules.stylix

        # System
        bootloader
        #limine
        networking
        settings
        user
        graphics
        intel
        regreet
        bluethooth
        sound
        stylix
        neovim
        zsh
    ];

    services.upower.enable = true;
    services.tlp.enable = true;

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "alacritty";

    services.gvfs.enable = true;

    networking.wg-quick.interfaces.wg0 = {
        address = [ "10.8.0.3/24" ];
        dns = [ "1.1.1.1" ];
        peers = [
            {
                allowedIPs = [
                    "10.8.0.0/24"
                    "10.10.12.0/24"
                ];
                endpoint = "public.ipv64.de:51820";
                publicKey = "hy12YOG6MaWwA3JeqGpDzt0XXSg/qsErxIRntlVrzHU=";
                presharedKeyFile = config.age.secrets.wireguard-shrKey.path;
            }
        ];
        privateKeyFile = config.age.secrets.wireguard-priKey.path;
    };

    age.secrets = {
       wireguard-priKey.file = ./secrets/wireguard-priKey.age;
       wireguard-shrKey.file = ./secrets/wireguard-shrKey.age;
    };

    programs.localsend.enable = true;

    services.openssh.enable = true;

    environment.systemPackages = with pkgs; [
        vlc
        supersonic-wayland
        inputs.quickshell.packages.${system}.quickshell
        inputs.ragenix.packages.${system}.default
        ferrishot
        signal-desktop
        orca-slicer
        # Programs
        nautilus
        hyprpicker
        geeqie
        # Other
        home-manager
    ];

    system.stateVersion = "25.05"; # Just don't
}
