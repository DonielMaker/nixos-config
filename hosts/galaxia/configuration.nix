{inputs, config, pkgs, system, ...}:

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

        intel

        regreet

        bluethooth
        sound

        neovim
        zsh
    ];

    services.upower.enable = true;

    programs.nautilus-open-any-terminal.enable = true;
    programs.nautilus-open-any-terminal.terminal = "kitty";

    networking.search = [ "thematt.net" ];

    networking.wg-quick.interfaces.wg0 = {
        address = [ "10.10.14.6/24" ];
        dns = [ "1.1.1.1" ];
        peers = [
            {
                allowedIPs = [
                    "10.10.14.0/24"
                    "10.10.12.0/24"
                ];
                endpoint = "87.186.6.152:51820";
                publicKey = "Ltmlc2mcJuKprhi5l6rU2hwMqejwQIQ/GFZB+sEckCQ=";
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
        inputs.quickshell.packages.${system}.quickshell
        inputs.ragenix.packages.${system}.default
        ferrishot
        zenity
        # Programs
        nautilus
        hyprpicker
        geeqie
        # Other
        home-manager
    ];

    system.stateVersion = "24.11"; # Just don't
}
