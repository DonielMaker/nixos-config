{ config, lib, ... }: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.desktop.bluetooth;
in

{
    options.modules.desktop.bluetooth.enable = mkEnableOption "Enable bluetooth";

    config = mkIf cfg.enable {

        hardware.bluetooth.enable = true;
        hardware.bluetooth = {
            powerOnBoot = true;
            settings = {
                General = {
                    Enable = "Source,Sink,Media,Socket";
                    Experimental = true;
                };
            };
        };
    };
}
