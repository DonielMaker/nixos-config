{config, ...}:

{
    # Outline: Note-Taking Server
    services.outline.enable = true;
    systemd.services.outline.environment.OIDC_LOGOUT_URI = "https://homepage.${config.modules.server.domain}";
    services.outline = {
        secretKeyFile = config.age.secrets.outlineSecretKey.path;
        utilsSecretFile = config.age.secrets.outlineUtilsSecret.path;
        port = 2920;
        publicUrl = "https://outline.${config.modules.server.domain}";
        forceHttps = false;
        concurrency = 4;
        defaultLanguage = "en_US";
        storage = {
            storageType = "local";
            localRootDir = "/storage/outline";
        };
        oidcAuthentication = {
            clientId = "outline";
            clientSecretFile = config.age.secrets.outlineClientSecret.path;
            authUrl = "https://authelia.${config.modules.server.domain}/api/oidc/authorization";
            tokenUrl = "https://authelia.${config.modules.server.domain}/api/oidc/token";
            userinfoUrl = "https://authelia.${config.modules.server.domain}/api/oidc/userinfo";
            usernameClaim = "preferred_username";
            displayName = "Authelia";
            scopes = [ "openid" "offline_access" "profile" "email" ];
        };
    };
}
