{config, domain, ...}:
{
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy.enable = true;
    services.caddy.extraConfig = ''
        *.${domain}, *.lastprism.${domain} {
            tls /var/lib/acme/${domain}/cert.pem /var/lib/acme/${domain}/key.pem {
                protocols tls1.3
            }

            @authentik host authentik.${domain}
            handle @authentik {
                reverse_proxy miasma.${domain}:9000
            }

            @vaultwarden host vaultwarden.${domain}
            handle @vaultwarden {
                reverse_proxy miasma.${domain}:5902
            }

            @homepage host homepage.${domain}
            handle @homepage {
                route {
                    reverse_proxy /outpost.goauthentik.io/* http://miasma.${domain}:9000

                    forward_auth http://miasma.${domain}:9000 {
                        uri /outpost.goauthentik.io/auth/caddy
                        copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version
                    }

                    reverse_proxy miasma.${domain}:8082
                }
            }

            @grafana host grafana.${domain} 
            handle @grafana {
                reverse_proxy miasma.${domain}:6778
            }

            @paperless host paperless.${domain}
            handle @paperless {
                reverse_proxy lastprism.${domain}:28981
            }

            @navidrome host navidrome.${domain} 
            handle @navidrome {
                reverse_proxy lastprism.${domain}:4533
            }

            @copyparty host copyparty.${domain} 
            handle @copyparty {
                reverse_proxy lastprism.${domain}:3923
            }

            @home-assistant host home-assistant.${domain} 
            handle @home-assistant {
                reverse_proxy lastprism.${domain}:8123
            }

            @zigbee2mqtt host zigbee2mqtt.${domain} 
            handle @zigbee2mqtt {
                route {
                    reverse_proxy /outpost.goauthentik.io/* http://miasma.${domain}:9000

                    forward_auth http://miasma.${domain}:9000 {
                        uri /outpost.goauthentik.io/auth/caddy
                        copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version
                    }

                    reverse_proxy miasma.${domain}:8080
                }
            }

            @prometheus host prometheus.${domain} 
            handle @prometheus {
                route {
                    reverse_proxy /outpost.goauthentik.io/* http://miasma.${domain}:9000

                    forward_auth http://miasma.${domain}:9000 {
                        uri /outpost.goauthentik.io/auth/caddy
                        copy_headers X-Authentik-Username X-Authentik-Groups X-Authentik-Entitlements X-Authentik-Email X-Authentik-Name X-Authentik-Uid X-Authentik-Jwt X-Authentik-Meta-Jwks X-Authentik-Meta-Outpost X-Authentik-Meta-Provider X-Authentik-Meta-App X-Authentik-Meta-Version
                    }

                    reverse_proxy miasma.${domain}:9090
                }
            }

            @proxmox-lastprism host proxmox.${domain} 
            handle @proxmox-lastprism {
                reverse_proxy proxmox.lastprism.${domain}:8006 {
                    transport http { tls_insecure_skip_verify }
                }
            }
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
