{ config, lib, ... }:

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.programs.vesktop;
in

{
    options.modules.programs.vesktop.enable = mkEnableOption "Enable Vesktop";

    config.home-manager.users.${config.modules.system.username} = mkIf cfg.enable {

        programs.vesktop.enable = true;
        programs.vesktop.vencord.useSystem = true;
    };
}
