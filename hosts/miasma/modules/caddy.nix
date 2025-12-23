{config, domain, ...}:
{
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy.enable = true;
    services.caddy.extraConfig = ''
        *.${domain}, *.lastprism.${domain} {
            tls /var/lib/acme/${domain}/cert.pem /var/lib/acme/${domain}/key.pem {
                protocols tls1.3
            }

            @authelia host authelia.${domain}
            handle @authelia {
                reverse_proxy miasma.${domain}:9091
            }

            @lldap host lldap.${domain}
            handle @lldap {
                reverse_proxy miasma.${domain}:17170
            }

            @homepage host homepage.${domain}
            handle @homepage {
                forward_auth miasma.${domain}:9091 {
                    uri /api/authz/forward-auth
                    copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
                }
                reverse_proxy miasma.${domain}:8082
            }

            @grafana host grafana.${domain} 
            handle @grafana {
                reverse_proxy miasma.${domain}:6778
            }

            @paperless host paperless.${domain}
            handle @paperless {
                forward_auth miasma.${domain}:9091 {
                    uri /api/authz/forward-auth
                    copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
                }
                reverse_proxy lastprism.${domain}:28981
            }

            @trilium host trilium.${domain}
            handle @trilium {
                reverse_proxy lastprism.${domain}:8965
            }

            @navidrome host navidrome.${domain} 
            handle @navidrome {
                reverse_proxy lastprism.${domain}:4533
            }

            @copyparty host copyparty.${domain} 
            handle @copyparty {
                reverse_proxy lastprism.${domain}:3923
            }

            @radicale host radicale.${domain} 
            handle @radicale {
                reverse_proxy lastprism.${domain}:5232
            }

            @home-assistant host home-assistant.${domain} 
            handle @home-assistant {
                reverse_proxy lastprism.${domain}:8123
            }

            @zigbee2mqtt host zigbee2mqtt.${domain} 
            handle @zigbee2mqtt {
                forward_auth miasma.${domain}:9091 {
                    uri /api/authz/forward-auth
                    copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
                }
                reverse_proxy lastprism.${domain}:8080
            }

            @prometheus host prometheus.${domain} 
            handle @prometheus {
                reverse_proxy miasma.${domain}:9090
            }

            @proxmox-lastprism host proxmox.${domain} 
            handle @proxmox-lastprism {
                reverse_proxy proxmox.lastprism.${domain}:8006 {
                    transport http { tls_insecure_skip_verify }
                }
            }

            # While this does work, it doesn't fit the suitcase of copyparty as it is also reachable outside a 
            # browser (where headers don't matter/work)
            # @copyparty host copyparty.${domain} 
            # handle @copyparty {
            #     forward_auth nixos.lastprism.${domain}:9091 {
            #         uri /api/authz/forward-auth
            #         copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            #     }
            #     reverse_proxy nixos.lastprism.${domain}:3923 {
            #         header_up X-Idp-User {http.request.header.Remote-User}
            #         header_up X-Idp-Group {http.request.header.Remote-Groups}
            #     }
            # }
        }
    '';

    security.acme = {
        acceptTerms = true;
        defaults.email = "daniel.schmidt0204@gmail.com";
        # defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
        defaults.server = "https://acme-v02.api.letsencrypt.org/directory";

        certs."${domain}" = {
            group = config.services.caddy.group;

            domain = "${domain}";
            extraDomainNames = [ 
                "*.${domain}"
                "*.lastprism.${domain}"
            ];
            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            dnsPropagationCheck = true;
            environmentFile = config.age.secrets.cloudflareDnsApiToken.path;
        };
    };
}
