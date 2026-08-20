{ config, lib, inputs, ... }: 

let
    inherit (lib) mkEnableOption mkOption mkIf types;
    cfg = config.modules.system;
in

{
    options = {

        modules.system.enable = mkEnableOption "Enable System";

        settings = {

            username = mkOption {
                type = types.str;
                description = "Sets the username of the machine";
            };

            mail = mkOption {
                type = types.str;
                description = "Sets the mail account";
            };
        };
    };

    imports = with inputs; [
        disko.nixosModules.disko
        ragenix.nixosModules.default
    ];

    config = mkIf cfg.enable {

        networking.networkmanager.enable = true;
        networking.domain = "thematt.net";

        time.timeZone = "Europe/Berlin";

        nix.settings.experimental-features = [ "nix-command" "flakes" ];
    };
}
