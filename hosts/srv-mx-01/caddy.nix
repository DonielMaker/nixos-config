{config, ...}:

{
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy.enable = true;
    services.caddy.extraConfig = ''
        *.srv-plp.ipv64.de {
            tls /var/lib/acme/srv-plp.ipv64.de/cert.pem /var/lib/acme/srv-plp.ipv64.de/key.pem {
                protocols tls1.3
            }

            # @authelia host authelia.srv-plp.ipv64.de
            # handle @authelia {
            #     reverse_proxy nixos.lastprism.srv-plp.ipv64.de:9091
            # }

            # @lldap host lldap.srv-plp.ipv64.de
            # handle @lldap {
            #     reverse_proxy nixos.lastprism.srv-plp.ipv64.de:17170
            # }

            @wireguard host wireguard.srv-plp.ipv64.de 
            handle @wireguard {
                reverse_proxy 192.168.178.20:51821
            }

            @erpnext host erpnext.srv-plp.ipv64.de 
            handle @erpnext {
                reverse_proxy 192.168.178.218:8080
            }

            # @paperless host paperless.srv-plp.ipv64.de 
            # handle @paperless {
            #     reverse_proxy 10.10.12.3:28981
            # }

            # @opencloud host opencloud.srv-plp.ipv64.de
            # handle @opencloud {
            #     reverse_proxy nixos.lastprism.srv-plp.ipv64.de:9200
            # }
        }
    '';

    security.acme = {
        acceptTerms = true;
        defaults.email = "solut-administrator@proton.me";
        # defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
        defaults.server = "https://acme-v02.api.letsencrypt.org/directory";

        certs."srv-plp.ipv64.de" = {
            group = config.services.caddy.group;

            domain = "srv-plp.ipv64.de";
            # extraDomainNames = [ ];
            dnsProvider = "ipv64";
            dnsResolver = "1.1.1.1:53";
            dnsPropagationCheck = true;
            environmentFile = config.age.secrets.ipv64DnsApiToken.path;
        };
    };
}

