{ config, lib, ... }: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.system.systemd-boot;
in

{
    options.modules.system.systemd-boot.enable = mkEnableOption "Enable Systemd-Boot";

    config = mkIf cfg.enable {

        # Use the systemd-boot EFI boot loader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
    };
}
