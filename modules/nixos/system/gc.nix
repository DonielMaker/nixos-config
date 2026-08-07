{ config, lib, ... }: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.system.gc;
in

{
    options.modules.system.gc.enable = mkEnableOption "Enable Nix garbage collection";

    config = mkIf cfg.enable {

        nix.gc = {
            automatic = true;
            options = "--delete-older-than 30d";
            dates = [ "Mon *-*-* 03:00:00"];
        };
    };
}
