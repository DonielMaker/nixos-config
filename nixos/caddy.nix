{config, ...}:

{
    services.caddy.enable = true;
    services.caddy.extraConfig = ''
        *.thematt.net {
            tls /var/lib/acme/thematt.net/cert.pem /var/lib/acme/thematt.net/key.pem {
                protocols tls1.3
            }

            authelia.thematt.net {
                reverse-proxy: localhost:9091
            }

            api.lldap.thematt.net {
                reverse-proxy: localhost:1000
            }

            lldap.thematt.net {
                reverse-proxy: localhost:1000
            }
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
            environmentFile = config.age.secrets.cloudflare.path;
        };
    };

    services.whoami.enable = true;
}
