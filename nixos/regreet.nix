{pkgs, config,  ...}: 

let
    hyprConf = pkgs.writeText "hyprland.conf" ''
        exec-once = ${config.programs.regreet.package}/bin/regreet; hyprctl dispatch exit
        misc {
            disable_hyprland_logo = true
            disable_splash_rendering = true
            # disable_hyprland_qtutils_check = true
        }
    '';
    
    variant = "macchiato";

    image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/DonielMaker/wallpapers/main/rohit-tandon-9wg5jCEPBsw-unsplash.jpg";
        sha256 = "sha256-qSUv2rCHWB2fYwL2Gd8d8LeQKKtM4aEljshaFbirB0g=";
    };
in

{
    services.greetd.enable = true;
    services.greetd.settings = {
        default_session = {
            command = "Hyprland --config ${hyprConf}";
        };
    };

    environment.systemPackages = with pkgs; [
        regreet
    ];

    programs.regreet.enable = true;
    programs.regreet = {

        settings = {
            background.path = "${image}";
            background.fit = "Cover";

            timezone = "Germany/Berlin";
        };

        # Not working :/
        extraCss = ''
            .background {
                background-color: rgba(36, 39, 58, 0.7);
            }
        '';
    };
}
