{ config, lib, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.sftpgo;
in

{
    options.modules.server.sftpgo.enable = mkEnableOption "Enable SFTPGo}";

    config = mkIf cfg.enable {

        networking.firewall.allowedTCPPorts = [ 4856 9837 ];

        # SFTPGo: Fileserver with Virtual Folders and RBAC
        users.users.${config.modules.system.username}.extraGroups = [ "media" ];
        users.groups.media = {};

        services.sftpgo.enable = true;
        services.sftpgo = {
            # No actual data but holds sftpgo.db
            # dataDir = "/var/lib/sftpgo";
            # Needed when dataDir != <your-wanted-dir>
            extraReadWriteDirs = [ "/storage/media" ];
            # Allow other services to read files
            group = "media";
            settings = {
                ## Sets dirs to 750 and files to 640
                common.umask = "027";

                httpd.bindings = [
                    {
                        address = "0.0.0.0";
                        port = 4856;

                        oidc = {
                            client_id = "sftpgo";
                            client_secret_file = "${config.age.secrets.sftpgo-clientSecret.path}";
                            config_url = "https://authelia.${config.modules.server.domain}";
                            # Url to redirect to. != Redirect Url for OIDC which is https://sftpgo.example.com/web/oidc/redirect
                            redirect_base_url = "https://sftpgo.${config.modules.server.domain}";
                            scopes = [ "openid" "profile" "email" ];
                            username_field = "preferred_username";
                            implicit_roles = true;
                        };

                        security = {
                            enabled = true;
                            allowed_hosts = [ "sftpgo.${config.modules.server.domain}" ];
                        };

                        cors = {
                            enabled = true;
                            allowed_origins = [ "sftpgo.${config.modules.server.domain}" ];
                        };
                    }
                ];

                webdavd.bindings = [ { address = "0.0.0.0"; port = 9837; } ];
            };
        };
    };
}
