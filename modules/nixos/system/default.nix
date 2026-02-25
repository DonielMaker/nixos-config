{ config, lib, sLib, inputs, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption mkOption types;
    inherit (sLib) assertEnabled;
    cfg = config.modules.system;
in

{
    options.modules.system = {
        enable = mkEnableOption "Enable System";

        hostname = mkOption {
            default = "machine";
            type = types.str;
            description = "Sets the hostname of the machine";
        };

        username = mkOption {
            default = "user";
            type = types.str;
            description = "Sets the username of the machine";
        };

        timezone = mkOption {
            default = "Europe/Berlin";
            type = types.str;
            description = "Sets the timezone";
        };

        shell = mkOption {
            default = pkgs.bash;
            type = types.package;
            description = "Sets the user shell";
        };
    };

    imports = with inputs; [
        disko.nixosModules.disko
        ragenix.nixosModules.default
    ];

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.system.enable)
        ];

        time.timeZone = cfg.timezone;

        nix.settings.experimental-features = [ "nix-command" "flakes" ];
    };
}
