{inputs, pkgs, ...}:

{
    imports = [ ./hardware-configuration.nix ./disko.nix ];

    modules = {
        system = {
            enable = true;
            hostname = "galaxia";
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
            sound.enable = true;
            networking.enable = true;
            bluetooth.enable = true;

            stylix.enable = true;

            hyprland.enable = true;
            dms.enable = true;
        };

        programs = {
            zsh.enable = true;
        };
    };

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

        typst

        zathura
        brave
        gimp
        obs-studio
        geeqie
    ];

    system.stateVersion = "25.05"; # Just don't
}
