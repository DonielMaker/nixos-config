{ config, lib, sLib, pkgs, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    inherit (sLib) assertEnabled;
    cfg = config.modules.server.docker;
in

{
    options.modules.server.docker.enable = mkEnableOption "Enable Docker";

    config = mkIf cfg.enable {
        assertions = [
            (assertEnabled cfg config.modules.server.enable)
        ];

        virtualisation.containers.enable = true;
        virtualisation.docker.enable = true;
        users.users.${config.modules.system.username}.extraGroups = ["docker"];

        environment.systemPackages = with pkgs; [
            docker-compose
        ];
    };
}
