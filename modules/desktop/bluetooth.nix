{ config, lib, sLib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled ;
    cfg = config.modules.desktop.bluetooth;
in

{
    options.modules.desktop.bluetooth.enable = mkEnableOption "Enable Bluetooth";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.desktop.enable)
        ];

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

        services.blueman.enable = true;
    };
}
