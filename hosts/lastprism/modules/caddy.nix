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

            # While this does work, it doesn't fit the suitcase of copyparty as copyparty is also reachable outside a browser (where headers don't matter)
            # @copyparty host copyparty.thematt.net 
            # handle @copyparty {
            #     forward_auth nixos.lastprism.thematt.net:9091 {
            #         uri /api/authz/forward-auth
            #         copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            #     }
            #     reverse_proxy nixos.lastprism.thematt.net:3923 {
            #         header_up X-Idp-User {http.request.header.Remote-User}
            #         header_up X-Idp-Group {http.request.header.Remote-Groups}
            #     }
            # }

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

            @grafana host grafana.thematt.net 
            handle @grafana {
                reverse_proxy nixos.lastprism.thematt.net:6778
            }

            @home-assistant host home-assistant.thematt.net 
            handle @home-assistant {
                reverse_proxy nixos.lastprism.thematt.net:8123
            }

            @zigbee2mqtt host zigbee2mqtt.thematt.net 
            handle @zigbee2mqtt {
                reverse_proxy nixos.lastprism.thematt.net:8080
            }

            @prometheus host prometheus.thematt.net 
            handle @prometheus {
                reverse_proxy nixos.lastprism.thematt.net:9090
            }

            @zitadel host zitadel.thematt.net 
            handle @zitadel {
                reverse_proxy nixos.lastprism.thematt.net:4443
            }

            @proxmox-lastprism host proxmox.lastprism.thematt.net 
            handle @proxmox-lastprism {
                reverse_proxy 10.10.12.12:8006 {
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
