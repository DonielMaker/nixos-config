{ config, lib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.programs.virt-manager;
in

{
    options.modules.programs.virt-manager.enable = mkEnableOption "Enable Virt-manager";

    config = mkIf cfg.enable {

        programs.dconf.enable = true;

        virtualisation.libvirtd.enable = true;
        programs.virt-manager.enable = true;
        users.users.${config.modules.system.username}.extraGroups = [ "libvirtd" ];

    };
}
