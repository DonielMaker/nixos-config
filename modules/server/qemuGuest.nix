{ config, lib, ... }: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.qemuGuest;
in

{
    options.modules.server.qemuGuest.enable = mkEnableOption "Enable Qemu Guest Agent";

    config = mkIf cfg.enable {

        services.qemuGuest.enable = true;
    };
}
