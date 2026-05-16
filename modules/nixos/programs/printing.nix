{ config, lib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.programs.printing;
in

{
    options.modules.programs.printing.enable = mkEnableOption "Enable Printing";

    config = mkIf cfg.enable {

        services.printing.enable = true;

        services.avahi.enable = true;
        services.avahi = {
            nssmdns4 = true;
            openFirewall = true;
        };
    };
}
