{config, ...}:

{
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy.enable = true;
    services.caddy.extraConfig = ''
        *.thematt.net, *.vilethorn.thematt.net, *.lastprism.thematt.net {
            tls /var/lib/acme/thematt.net/cert.pem /var/lib/acme/thematt.net/key.pem {
                protocols tls1.3
            }

            @authelia host authelia.thematt.net
            handle @authelia {
                reverse_proxy nixos.lastprism.thematt.net:9091
            }

            @lldap host lldap.thematt.net
            handle @lldap {
                reverse_proxy nixos.lastprism.thematt.net:17170
            }

            @navidrome host navidrome.thematt.net 
            handle @navidrome {
                reverse_proxy nixos.lastprism.thematt.net:4533
            }

            @copyparty host copyparty.thematt.net 
            handle @copyparty {
                reverse_proxy nixos.lastprism.thematt.net:3923
            }

            @homepage host homepage.thematt.net
            handle @homepage {
                reverse_proxy nixos.lastprism.thematt.net:8082
            }

            @radicale host radicale.thematt.net 
            handle @radicale {
                reverse_proxy nixos.lastprism.thematt.net:5232
            }

            @proxmox-lastprism host proxmox.lastprism.thematt.net 
            handle @proxmox-lastprism {
                reverse_proxy 10.10.12.12:8006 {
                    transport http {
                        tls_insecure_skip_verify
                    }
                }
            }

            @paperless host paperless.thematt.net 
            handle @paperless {
                reverse_proxy nixos.lastprism.thematt.net:28981
            }
        }
    '';

    security.acme = {
        acceptTerms = true;
        defaults.email = "daniel.schmidt0204@gmail.com";
        # defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
        defaults.server = "https://acme-v02.api.letsencrypt.org/directory";

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
}
