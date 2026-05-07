{ config, lib, pkgs, ... }: 

let
    inherit (lib) mkEnableOption mkOption mkIf types;
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

        environment.systemPackages = with pkgs; [

            vim
            git

            restic # Backups
        ];
    };
}
