{ config, lib, sLib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled assertCollision;
    cfg = config.modules.system.systemd-boot;
in

{
    options.modules.system.systemd-boot.enable = mkEnableOption "Enable Systemd-Boot";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.system.enable)
            (assertCollision cfg config.modules.system.limine.enable)
        ];

        # Use the systemd-boot EFI boot loader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
    };
}
