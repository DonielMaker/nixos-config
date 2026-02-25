{ config, lib, sLib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.server.qemuGuest;
in

{
    options.modules.server.qemuGuest.enable = mkEnableOption "Enable Qemu Guest Agent";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.server.enable)
        ];

        services.qemuGuest.enable = true;
    };
}
