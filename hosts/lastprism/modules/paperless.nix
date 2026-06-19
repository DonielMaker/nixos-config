{ config, lib, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.paperless;
in

{
    options.modules.server.paperless.enable = mkEnableOption "Enable Paperless";

    config = mkIf cfg.enable {

        networking.firewall.allowedTCPPorts = [ 28981 ];

        # Paperless: A Document server with plenty of features (ocr, file conversion, editing, etc.)
        services.paperless.enable = true;
        services.paperless = {
            address = "0.0.0.0";
            port = 28981;
            dataDir = "/storage/paperless";
            configureTika = true;
            ## Also holds SSO
            environmentFile = config.age.secrets.paperless-envFile.path;

            settings = {
                PAPERLESS_URL = "https://paperless.${config.modules.server.domain}";
                PAPERLESS_OCR_LANGUAGE = "eng+deu";
                PAPERLESS_TIME_ZONE = "Europe/Berlin";
                PAPERLESS_TRUSTED_PROXIES = "10.10.12.0/24";
                PAPERLESS_USE_X_FORWARDED_HOST = true;
                PAPERLESS_USE_X_FORWARDED_PORT = true;

                # SSO
                PAPERLESS_LOGOUT_REDIRECT_URL = "https://homepage.${config.modules.server.domain}";
                PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
            };
        };
    };
}
