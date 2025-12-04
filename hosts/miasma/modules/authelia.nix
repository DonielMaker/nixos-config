{config, domain, ...}: 

{
    services.redis.servers.authelia-main = {
        enable = true;
        user = "authelia-main";   
        port = 0;
        unixSocket = "/run/redis-authelia-main/redis.sock";
        unixSocketPerm = 600;
    };

    services.authelia.instances.main = {
        enable = true;
        secrets = {
            jwtSecretFile = config.age.secrets.jwtSecret.path;
            storageEncryptionKeyFile = config.age.secrets.storageEncryptionKey.path;
            sessionSecretFile = config.age.secrets.sessionSecret.path;
            oidcIssuerPrivateKeyFile = config.age.secrets.autheliaJwksKey.path;
        };
        environmentVariables = {
            "AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE" = config.age.secrets.autheliaLldapPassword.path;
        };
        settings = {
            theme = "dark";
            log = {
                level = "debug";
                format = "text";
            };
            access_control = {
                default_policy = "deny";
                rules = [
                    {
                        domain = ["authelia.${domain}"];
                        policy = "bypass";
                    }
                    {
                        domain = ["*.${domain}"];
                        policy = "one_factor";
                    }
                ];
            };
            notifier = {
                disable_startup_check = false;
                filesystem = {
                    filename = "/var/lib/authelia-main/notification.txt";
                };
            };
            session = {
                name = "authelia_session";
                expiration = "12h";
                inactivity = "45m";
                remember_me = "1M";
                redis.host = "/run/redis-authelia-main/redis.sock";
                cookies = [
                    {
                        domain = "${domain}";
                        authelia_url = "https://authelia.${domain}";
                        # default_redirection_url: 'https://www.example.com'
                        # same_site: 'lax'
                    }
                ];
            };
            storage.local.path = "/var/lib/authelia-main/db.sqlite3";
            regulation = {
                max_retries = 3;
                find_time = "5m";
                ban_time = "15m";
            };
            authentication_backend = {
                password_reset.disable =  true;
                password_change.disable = true;
                refresh_interval = "1m";
                ldap = {
                    address = "ldap://miasma.${domain}:3890";
                    implementation = "lldap";
                    timeout = "5s";
                    base_dn = "dc=thematt,dc=net";
                    additional_users_dn = "ou=people";
                    user = "uid=authelia,ou=people,dc=thematt,dc=net";
                };
            };
            totp = {
                disable = false;
                algorithm = "sha1";
                digits = 6;
                period = 30;
            };
            identity_providers = {
                oidc = {
                    lifespans = {
                        access_token = "1h";
                        authorize_code = "1m";
                        id_token = "1h";
                        refresh_token = "90m";
                    };
                    enable_client_debug_messages = true;
                    require_pushed_authorization_requests = false;
                    cors = {
                        endpoints= [
                            "authorization"
                            "token"
                            "revocation"
                            "introspection"
                        ];
                        allowed_origins= [ "https://*.${domain}" ];
                    };
                    clients = [
                        {
                            client_id = "proxmox";
                            client_name = "Proxmox";
                            client_secret = "$argon2id$v=19$m=65536,t=3,p=4$FGfPJgtAdjDEe0wf8cFgLA$3wanv1DOfrRt5a1476gYmQkQtKorJLX5qRStYrXjEUQ";
                            public = false;
                            require_pkce= true;
                            pkce_challenge_method = "S256";
                            authorization_policy = "two_factor";
                            redirect_uris = [ "https://proxmox.${domain}" ];
                            scopes = [ "openid" "profile" "email" "groups" ];
                            response_types = [ "code" ];
                            grant_types = [ "authorization_code" ];
                            access_token_signed_response_alg = "none";
                            userinfo_signed_response_alg = "none";
                            token_endpoint_auth_method = "client_secret_basic";
                        }
                        {
                            client_id = "trilium";
                            client_name = "Trilium";
                            client_secret = "$argon2id$v=19$m=65536,t=3,p=4$iAW7Z2DFdH+YFa80y6SeQw$a2UwF29+g33+vWQIlwLP4h2PyMQhKodYP6EPwDsz6fM";
                            public = false;
                            # require_pkce= true;
                            # pkce_challenge_method = "S256";
                            authorization_policy = "two_factor";
                            redirect_uris = [ "https://trilium.${domain}/callback" ];
                            scopes = [ "openid" "profile" "email" ];
                            response_types = [ "code" ];
                            grant_types = [ "authorization_code" ];
                            access_token_signed_response_alg = "none";
                            userinfo_signed_response_alg = "none";
                            token_endpoint_auth_method = "client_secret_basic";
                        }
                        {
                            client_id = "grafana";
                            client_name = "Grafana";
                            client_secret = "$argon2id$v=19$m=65536,t=3,p=4$scu44e90oai9rSdSyOXw9Q$IDHKR+f+Sle9zHpAQxbEYnXSCIQ+GrqQ1qWeCs8Uogg";
                            public = false;
                            require_pkce= true;
                            pkce_challenge_method = "S256";
                            authorization_policy = "two_factor";
                            redirect_uris = [ "https://grafana.${domain}/login/generic_oauth" ];
                            scopes = [ "openid" "profile" "email" "groups" ];
                            response_types = [ "code" ];
                            grant_types = [ "authorization_code" ];
                            access_token_signed_response_alg = "none";
                            userinfo_signed_response_alg = "none";
                            token_endpoint_auth_method = "client_secret_basic";
                        }
                    ];
                };
            };
        };
    };
}
