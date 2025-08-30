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
            identity_providers = {
                oidc = {
# hmac_secret = "this_is_a_secret_abc123abc123abc";
                    jwks = [
                        {
                            # key = ''{{ secret "${config.age.secrets."private.pem".path}" | minindent 10 "|" msquote }}'';
                            key = 
''-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDu0gDzjRSZsico
lZVsR7FJhhA3ImeL+sg82j/fXYvN6oEk26lgIipD+r/zIgNoBYaaDpNL94RzZ3JN
W5FuMq15oFEC1gTS/MekfMuD+gG0t5pCuCwt3cC11dZP+b8C/mhdRk+tvMElbVml
zY5B7QcwtItrxwI8qTfINDifgqeRdCchFUcfsahJbg72aifs2jua+HHk5ZqVajId
Wa26Dq2aJqAom2mWp7fFjB+GThSFSOa1+oYHtu7IlP+XpCyppO1961zEsoD5n732
whreEFsV2r/SlPOY81DJBD57KBvgu78H2c46NSRkyKh6QJL88u6lFxbjb4WjYfxg
pu9Lj+/rAgMBAAECggEALqiQzwSNNcn8pI00+Ea5eGfc2yi5mjuQy3LIb9dS7RQX
zx+rY8DJCScAQXwvti7+MTMPzBO7qOBZEIwHScRU6CJOMYOmxaHlT1miWVKK6sfE
N6zL1NoyQFRa3p0omGkj8rU98++gvLM0hJQ4auDoOrfLVW84HKni4BZzyZY5Ls1l
/Gj++X3ja9sXN6NTD4EnbgdqOve/VQmSoqGf7RVSinbuWPAPqhodkw/IHIEdiKMP
Cz0FGeoTAOiE340ZBjf4lyYJOf0FZyE15r3MduiTwzyNENMxMxaZKcB3i4c4GqoD
MF76y7zKG91WfSyVwFwZCEQHlkuwvOwE9/TWeJ5cYQKBgQD/i/4Al8Ag3w0ZIo/e
40JzE0ez0V+dmJH9wCF823z8Srb7s9P+br5XnlMfIt79tOTN7mRyPvc9hQUfJAQp
LPFdoH3eiH7ueMHf72BQzgKCDRAfFATft3qj+k2YnBgxa3WFVzZE3Im40EiCrXOe
Wj5XGREi6jYKWqbEnIFi/Et3tQKBgQDvPmsaA+Mx96T1Ihjuh3gicDNqnVxa8U9f
tN3tjmjAv+53btALOP2doWW5XWlKSGvw04BROe4PQUCV/lef7pDgatnaC8WJ8WtS
jaqAoarx/YI+lmkCZo3IjULl7nEsPWjRRmN+Rme5dnDnxObPG8ApGB5Es6klYPLX
t3l5Kp9NHwKBgHhG7bBdvGI8Wa/g4pJnqJj9FByAiV5ltyEV0y0vKW6dw+5IP5lb
il8296yJ/yaug5qhf8l99WSRPU3g58xxiNEmftfEqumXELlTs6OUsv1/JH1cMMcT
VrfjUa5omcJ474FpAPP8UR4Zemd3OBnqI7le5P/n+LN6409a0lNCqEqZAoGBAIdr
ZWRMXwWhj5XRvxsFQ1L6/5+Rgv1XKf6aeiRFP7Ya7fhcmRZBJA1dlh7eaQLLC449
qZxQlhe8b7p3RVIZz5e346gwkZgLNxx7Y897sy9Wt6qFqNrbAdZLX1qXJShNek86
8IZBg+TOzgniwmLo6lRYeomYyF2ICu1fxTp4jcMxAoGBAJp3yArOO8YCLxAcfni4
EwR0v9G4MDqIh+IbjCX4H0Tt+4doJABeDGXn6xxcpwKLBgCrSSkB3jt+IfcKeuww
NK9iY/qavsvwYFA84O0rEnb1uzN/RES/bE+3CVucmobhBFjZ5qZMHbVC1tZNSsfI
OOgp6OSXLu5imu8gkIrqxA+e
-----END PRIVATE KEY-----'';
                        }
                    ];
                    lifespans = {
                        access_token = "1h";
                        authorize_code = "1m";
                        id_token = "1h";
                        refresh_token = "90m";
                    };
                    enable_client_debug_messages = false;
                    enforce_pkce = "public_clients_only";
                    require_pushed_authorization_requests = false;
                    cors = {
                        endpoints= [
                            "authorization"
                                "token"
                                "revocation"
                                "introspection"
                        ];
                        allowed_origins= [ "https://*.thematt.net" ];
                    };
                    clients = [
                        {
                            client_id = "proxmox";
                            client_name = "Proxmox";
                            client_secret = "OT3TzdNZsvJi&OYnbUJGP3hMYV2mS*Fj8gUCu5s%F30q^4ukw3iOoHLkjRd%q$d@";
                            public = false;
                            authorization_policy = "two_factor";
                            require_pkce = true;
                            pkce_challenge_method = "S256";
                            redirect_uris = [
                                "https://proxmox.lastprism.thematt.net"
                                # "https://proxmox.lastprism.thematt.net/api2/json/access/ticket?realm=Authelia"
                            ];
                            scopes = [
                                "openid"
                                "profile"
                                "email"
                                "groups"
                            ];
                            response_types = [
                                "code"
                            ];
                            grant_types = [
                                "authorization_code"
                            ];
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
