{ config, lib, pkgs, sLib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertCollision;
    cfg = config.modules.desktop;
in

{
    options.modules.desktop.enable = mkEnableOption "Enable Desktop";

    config = mkIf cfg.enable {
        assertions = [
            (assertCollision cfg config.modules.server.enable)
        ];

        programs.localsend.enable = true;

        environment.systemPackages = with pkgs; [

            vim

            vlc
            libreoffice
            librewolf
            signal-desktop
            thunderbird
            gnupg
        ];
    };
}
