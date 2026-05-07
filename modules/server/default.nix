{ config, lib, sLib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption mkOption types;
    inherit (sLib) assertCollision;
    cfg = config.modules.server;
in

{
    options.modules.server = {
        enable = mkEnableOption "Enable Server config";

        domain = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = "Sets the domain";
        };
    };

    config = mkIf cfg.enable {
        assertions = [
            (assertCollision cfg config.modules.desktop.enable)
        ];

        environment.systemPackages = with pkgs; [
            restic
            vim
            git
        ];
    };
}
