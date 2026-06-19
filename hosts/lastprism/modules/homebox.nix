{ config, lib, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.homebox;
in

{
    options.modules.server.homebox.enable = mkEnableOption "Enable Homebox";

    config = mkIf cfg.enable {

        networking.firewall.allowedTCPPorts = [ 7745 ];

        # Homebox: Inventory Management for the Home Owner
        services.homebox.enable = true;
        systemd.services.homebox.serviceConfig.EnvironmentFile = config.age.secrets.homebox-envFile.path;
        services.homebox = {
            database.createLocally = true;
            settings = {
                HBOX_MODE = "production";
                HBOX_OPTIONS_CHECK_GITHUB_RELEASE = "false";
                HBOX_OPTIONS_TRUST_PROXY = "true";

                # Directories
                HBOX_STORAGE_CONN_STRING = "file:///storage/homebox";
                HBOX_STORAGE_PREFIX_PATH = "data";
                HOME = "/storage/homebox";
                TMPDIR = "/storage/homebox/tmp";

                # OIDC
                HBOX_OIDC_ENABLED = "true";
                HBOX_OIDC_ISSUER_URL = "https://authelia.${config.modules.server.domain}";
                HBOX_OIDC_CLIENT_ID = "homebox";
                HBOX_OIDC_SCOPE = "openid profile email groups";
                # HBOX_OPTIONS_ALLOW_REGISTRATION = "true";
            };
        };
    };
}
