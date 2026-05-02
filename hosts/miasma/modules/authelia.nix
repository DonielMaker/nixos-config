{config, pkgs, ...}: 

let
    domain = config.modules.server.domain;
in

{
    services.redis.servers.authelia-main = {
        enable = true;
        user = config.services.authelia.instances.main.user;   
        port = 0;
        unixSocket = "/run/redis-authelia-main/redis.sock";
        unixSocketPerm = 600;
    };

    services.authelia.instances.main = {
        enable = true;
        secrets = {
            jwtSecretFile = config.age.secrets.authelia-jwtSecret.path;
            sessionSecretFile = config.age.secrets.authelia-sessionSecret.path;
            storageEncryptionKeyFile = config.age.secrets.authelia-storageEncryptionKey.path;
            oidcIssuerPrivateKeyFile = config.age.secrets.authelia-oidcIssuerPrivateKey.path;
        };
        # environmentVariables."AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE" = config.age.secrets.autheliaLldapPassword.path;

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
                        default_redirection_url = "https://homepage.thematt.net";
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
                file.path = pkgs.writeText "authelia-users.yaml" ''
                    users:
                      donielmaker:
                        displayname: 'donielmaker'
                        given_name: 'Daniel'
                        family_name: 'Schmidt'
                        email: 'donielmaker@thematt.net'
                        password: '$argon2id$v=19$m=65536,t=3,p=4$auXi8F8w7AC1FzKRupIZ8A$n/gPbxg0CdwnWiiZhHOdawgoijFcCOfjyNvkRl7Uj6Y'
                        groups:
                        - 'admins'
                '';

                # ldap = {
                #     address = "ldap://miasma.${domain}:3890";
                #     implementation = "lldap";
                #     timeout = "5s";
                #     base_dn = "dc=thematt,dc=net";
                #     additional_users_dn = "ou=people";
                #     user = "uid=authelia,ou=people,dc=thematt,dc=net";
                # };
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
                    claims_policies = {
                      sftpgo.id_token = [ "preferred_username" ];
                    };
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
                            client_secret = "$argon2id$v=19$m=65536,t=3,p=4$8GicOeJbe6VdjNQJKr7fdA$vR0PxvmGMyANMWnjQKVKf7B52YFiVOoxy8WLNWudkFc";
                            authorization_policy = "two_factor";
                            public = false;
                            require_pkce = true;
                            pkce_challenge_method = "S256";
                            redirect_uris = [ "https://proxmox.${domain}" ];
                            scopes = [ "openid" "profile" "email" "groups" ];
                        }
                        {
                            client_id = "homebox";
                            client_name = "Homebox";
                            client_secret = "$argon2id$v=19$m=65536,t=3,p=4$kZEadPlBU2VmQy7VugJHMA$spMBKIRVROKnui4Wm8mk+OBLRSLvdyQkr3EggKPgV5I";
                            public = false;
                            require_pkce = true;
                            pkce_challenge_method = "S256";
                            authorization_policy = "two_factor";
                            redirect_uris = [ "https://homebox.${domain}/api/v1/users/login/oidc/callback" ];
                            scopes = [ "openid" "profile" "email" "groups" ];
                        }
                        {
                            client_id = "sftpgo";
                            client_name = "SFTPGo";
                            client_secret = "$argon2id$v=19$m=65536,t=3,p=4$55bpOwIegwyTiWiRgWOjIQ$6XalS30db6ryY2DT/vuspfcSXLlENos8bcHfFcz0bJI";
                            claims_policy = "sftpgo";
                            public = false;
                            authorization_policy = "two_factor";
                            redirect_uris = [ "https://sftpgo.${domain}/web/oidc/redirect" ];
                            scopes = [ "openid" "profile" "email" ];
                        }
                        {
                            client_id = "paperless";
                            client_name = "Paperless";
                            client_secret = "$argon2id$v=19$m=65536,t=3,p=4$4WrjcQRN30zZyy9GFfkJoQ$0GDIBRb9KezRnHDnUv/k1DlZTrO5AU/IWN96qB/SAZM";
                            public = false;
                            require_pkce = true;
                            pkce_challenge_method = "S256";
                            authorization_policy = "two_factor";
                            redirect_uris = [ "https://paperless.${domain}/accounts/oidc/authelia/login/callback/" ];
                            scopes = [ "openid" "profile" "email" "groups" ];
                        }
                    ];
                };
            };
        };
    };
}
