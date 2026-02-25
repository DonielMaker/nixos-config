{ config, lib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.programs.wayvnc;
in

{
    options.modules.programs.wayvnc.enable = mkEnableOption "Enable Wayvnc";

    config = mkIf cfg.enable {

        networking.firewall.allowedTCPPorts = [ 5900 ];

        programs.wayvnc.enable = true;
    };
}
