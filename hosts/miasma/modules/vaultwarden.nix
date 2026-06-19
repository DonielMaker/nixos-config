{ config, lib, ...}:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.vaultwarden;
in

{
    options.modules.server.vaultwarden.enable = mkEnableOption "Enable Vaultwarden";

    config = mkIf cfg.enable {
        networking.firewall.allowedTCPPorts = [ 5902 ];

        # Vaultwarden: Passwordmanager
        services.vaultwarden.enable = true;
        services.vaultwarden = {
            backupDir = "/storage/vaultwarden";
            environmentFile = config.age.secrets.vaultwardenEnv.path;
            config = {
                DOMAIN = "https://vaultwarden.${config.modules.server.domain}";
                ROCKET_ADDRESS = "0.0.0.0";
                ROCKET_PORT = 5902;
                IP_HEADER = "X-Forwarded-For";

                ADMIN_TOKEN = "$argon2id$v=19$m=65536,t=3,p=4$yw24wHrUcU5jnsLq1wC2zA$EfhTG1MS60r5Gb5D74VUzPo13a//GTFx9wlPSwh1xwQ";

                TRASH_AUTO_DELETE_DAYS = 30;
                SIGNUPS_ALLOWED = false;
                PASSWORD_HINTS_ALLOWED = false;

                SMTP_HOST = "mail.${config.modules.server.domain}";
                SMTP_FROM = "vaultwarden@${config.modules.server.domain}";
                SMTP_FROM_NAME = "Vaultwarden";
                SMTP_USERNAME = "admin@${config.modules.server.domain}";
            };
        };
    };
}
