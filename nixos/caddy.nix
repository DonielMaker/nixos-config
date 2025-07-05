{config, pkgs, ...}:

{
    services.caddy.enable = true;
    services.caddy.extraConfig = ''
        localhost {
            tls /var/lib/acme/thematt.net/cert.pem /var/lib/acme/thematt.net/key.pem {
                protocols tls1.3
            }

            reverse_proxy localhost:8000
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
