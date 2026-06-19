{ config, inputs, lib, pkgs, ... }: 

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
            inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

            git
            restic 
            vim
        ];
    };
}
