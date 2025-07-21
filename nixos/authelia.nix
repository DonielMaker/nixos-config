{pkgs, ...}: 

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
            jwtSecretFile = "${pkgs.writeText "jwtSecretFile" "ThisISVeryImportant"}";
            storageEncryptionKeyFile = "${pkgs.writeText "storageEncryptionKeyFile" "CiMS4659IskGSaL6m2GSVmNsjMi2cOgj"}";
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
                        domain = ["authelia.thematt.net"];
                        policy = "bypass";
                    }
                    {
                        domain = ["*.thematt.net"];
                        policy = "two_factor";
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
                        domain = "thematt.net";
                        authelia_url = "https://authelia.thematt.net";
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
                    address = "ldap://10.10.12.3:3890";
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
        };
    };
}
