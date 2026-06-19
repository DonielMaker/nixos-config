{ config, lib, ...}:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.navidrome;
in

{
    options.modules.server.navidrome.enable = mkEnableOption "Enable Navidrome";

    config = mkIf cfg.enable {

        # Navidrome: A Music server which uses the subsonic protocol to send content to clients
        services.navidrome.enable = true;
        services.navidrome = {
            openFirewall = true;
            group = "media";
            settings = {
                Address = "0.0.0.0";
                MusicFolder = "/storage/media/Music"; 
            };
        };
    };
}
