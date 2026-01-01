{config, pkgs, image,  ...}: 

let
    hyprConf = pkgs.writeText "hyprland.conf" ''
        exec-once = ${config.programs.regreet.package}/bin/regreet; hyprctl dispatch exit
        misc {
            disable_hyprland_logo = true
            disable_splash_rendering = true
            # disable_hyprland_qtutils_check = true
        }
    '';
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
            background.path = "${image.login}";
            background.fit = "Cover";

            timezone = "Europe/Berlin";
        };

        # Not working :/
        extraCss = ''
            .background {
                background-color: rgba(36, 39, 58, 0.7);
            }
        '';
    };
}
