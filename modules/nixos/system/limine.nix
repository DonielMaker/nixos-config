{ config, lib, ... }: 

let
    inherit (lib) mkEnableOption mkOption mkIf types;
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

        boot.loader.limine.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.limine = {
            efiSupport = true;
            maxGenerations = 10;
            style = {
                wallpapers = [ "${config.modules.system.limine.image}" ];
                interface.branding = "I use NixOS btw.";
                # Sets the backgrounds Opacity to zero
                graphicalTerminal.background = lib.mkForce "FFFFFFFF";
            };
        };
    };
}

