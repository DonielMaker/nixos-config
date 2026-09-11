{ config, inputs, lib, pkgs, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server;
in

{
    options.modules.server.enable = mkEnableOption "Enable Server config";

    config = mkIf cfg.enable {

        environment.systemPackages = with pkgs; [
            inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

            git
            restic 
            vim
        ];
    };
}
