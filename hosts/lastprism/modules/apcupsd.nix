{ config, lib, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.apcupsd;
in

{
    options.modules.server.apcupsd.enable = mkEnableOption "Enable APCUPSD";

    config = mkIf cfg.enable {

        # Had some port for remote access but i forgot and don't care to check
        # networking.firewall.allowedTCPPorts = [];

        services.apcupsd.enable = true;
        services.apcupsd.configText = ''
            UPSCABLE usb
            UPSTYPE usb
            DEVICE
            LOCKFILE /var/lock
            UPSCLASS standalone
            UPSMODE disable
        '';
    };
}
