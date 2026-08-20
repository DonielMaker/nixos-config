{ config, lib, ... }: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.system.networking;
in

{
    options.modules.system.networking.enable = mkEnableOption "Enable Networking";

    config = mkIf cfg.enable {

    };
}
