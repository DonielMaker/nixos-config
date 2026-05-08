{ config, lib, pkgs, ... }: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.podman;
in

{
    options.modules.server.podman.enable = mkEnableOption "Enable Podman";

    config = mkIf cfg.enable {

        virtualisation.containers.enable = true;
        virtualisation.podman.enable = true;
        virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

        environment.systemPackages = with pkgs; [
            podman-compose
        ];
    };
}
