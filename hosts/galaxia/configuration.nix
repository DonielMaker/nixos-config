{inputs, pkgs, ...}:

{
    imports = [ ./hardware-configuration.nix ./disko.nix ];

    networking.hostName = "galaxia";

    services.xserver.xkb.layout = "de";

    settings = {
        username = "donielmaker";
        mail = "daniel.schmidt0204@gmail.com";
    };

    modules = {
        system = {
            enable = true;

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

            bluetooth.enable = true;
            sound.enable = true;

            hyprland.enable = true;
            noctalia.enable = true;
            stylix.enable = true;
        };

        programs = {
            webdav.enable = true;
            printing.enable = true;
        };

        terminal = {
            alacritty.enable = true;
            git.enable = true;
            neovim.enable = true;
            starship.enable = true;
            zsh.enable = true;
        };
    };
    
    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

        # == Programs ==
        gimp # Image editing
        obs-studio # Video Recording
        simple-scan # Scanning Utility

        # == Utils ==
        cryptsetup # Encrypted Drives
        typst # Professional Documents
    ];

    system.stateVersion = "25.05"; # Just don't
}
