{ config, lib, sLib, ... }: 

let
    inherit (lib) mkIf mkEnableOption mkOption types;
    inherit (sLib) assertEnabled assertCollision;
    cfg = config.modules.system.limine;
in

{
    options.modules.system.limine = {
        enable = mkEnableOption "Enable Limine";

        image = mkOption {
            default = null;
            type = types.nullOr types.package;
            description = "Background image for Limine";
        };
    };

    config = mkIf cfg.enable {

        assertions = [
            (assertEnabled cfg config.modules.system.enable)
            (assertCollision cfg config.modules.system.systemd-boot.enable)
        ];

        boot.loader.limine.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.limine = {
            efiSupport = true;
            maxGenerations = 10;
            style = {
                wallpapers = [ "${config.modules.system.limine.image}" ];
                interface.branding = "Company Device";
                # Sets the backgrounds Opacity to zero
                graphicalTerminal.background = lib.mkForce "FFFFFFFF";
            };
        };
    };
}

