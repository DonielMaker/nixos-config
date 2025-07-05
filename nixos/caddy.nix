{config, pkgs, ...}:

{
    networking.hosts = {
        "127.0.0.1" = ["test.thematt.net" "lldap.thematt.net" "authelia.thematt.net" "api.lldap.thematt.net" "stirling.thematt.net"];
    };

    services.caddy.enable = true;
    services.caddy.extraConfig = ''
        stirling.thematt.net {
            tls /var/lib/acme/thematt.net/cert.pem /var/lib/acme/thematt.net/key.pem {
                protocols tls1.3
            }

            forward_auth localhost:9091 {
                uri /api/authz/forward-auth
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }

            reverse_proxy localhost:8080
        }

        test.thematt.net {
            tls /var/lib/acme/thematt.net/cert.pem /var/lib/acme/thematt.net/key.pem {
                protocols tls1.3
            }

            forward_auth localhost:9091 {
                uri /api/authz/forward-auth
                copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }

            reverse_proxy localhost:8000
        }

        authelia.thematt.net {
            tls /var/lib/acme/thematt.net/cert.pem /var/lib/acme/thematt.net/key.pem {
                protocols tls1.3
            }

            reverse_proxy localhost:9091
        }

        api.lldap.thematt.net {

            tls /var/lib/acme/thematt.net/cert.pem /var/lib/acme/thematt.net/key.pem {
                protocols tls1.3
            }

            reverse_proxy localhost:3490
        }

        lldap.thematt.net {
            tls /var/lib/acme/thematt.net/cert.pem /var/lib/acme/thematt.net/key.pem {
                protocols tls1.3
            }

            # reverse_proxy localhost:3490
            reverse_proxy localhost:17170
        }
    '';

    security.acme = {
        acceptTerms = true;
        defaults.email = "daniel.schmidt0204@gmail.com";
        defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";

        certs."thematt.net" = {
            group = config.services.caddy.group;

            domain = "thematt.net";
            extraDomainNames = [ "*.thematt.net" ];
            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            dnsPropagationCheck = true;
            environmentFile = "${pkgs.writeText "cloudflare-creds" ''
                CLOUDFLARE_DNS_API_TOKEN=8TmsoUzuMCsDfHZcv47kRZfg4Hm56ojUDCIWkxSL
                ''}";
        };
    };

    services.whoami.enable = true;
}
