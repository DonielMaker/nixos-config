{config, ...}:

{
    networking.firewall.allowedTCPPorts = [ 80 443 8000];
    services.caddy.enable = true;
    services.caddy.extraConfig = ''
        *.thematt.net {
            tls /var/lib/acme/thematt.net/cert.pem /var/lib/acme/thematt.net/key.pem {
                protocols tls1.3
            }

            @authelia host authelia.thematt.net
            handle @authelia {
                reverse_proxy 10.10.12.3:9091
            }

            @api-lldap host api.lldap.thematt.net
            handle @api-lldap {
                reverse_proxy 10.10.12.3:3890
            }

            @lldap host lldap.thematt.net
            handle @lldap {
                reverse_proxy 10.10.12.3:17170
            }

            @whoami host whoami.test.thematt.net
            handle @whoami {
                forward_auth 10.10.12.3:9091 {
                    uri /api/authz/forward-auth
                    copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
                }
                reverse_proxy 10.10.12.3:8000
            }

            @clst-1 host clst-1.thematt.net 
            handle @clst-1 {
                reverse_proxy 10.10.12.60:8006 {
                    transport http {
                        tls_insecure_skip_verify
                    }
                }
            }

            @clst-2 host clst-2.thematt.net 
            handle @clst-2 {
                reverse_proxy 10.10.12.61:8006 {
                    transport http {
                        tls_insecure_skip_verify
                    }
                }
            }

            @clst-3 host clst-3.thematt.net 
            handle @clst-3 {
                reverse_proxy 10.10.12.62:8006 {
                    transport http {
                        tls_insecure_skip_verify
                    }
                }
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
            extraDomainNames = [ 
                "*.thematt.net"
                "*.vilethorn.thematt.net"
                "*.lastprism.thematt.net"
            ];
            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            dnsPropagationCheck = true;
            environmentFile = config.age.secrets.cloudflareDnsApiToken.path;
        };
    };

    services.whoami.enable = true;
}
