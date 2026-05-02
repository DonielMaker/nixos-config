{config, ...}:

let
    domain = config.modules.server.domain;
in
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

            @vaultwarden host vaultwarden.${domain}
            handle @vaultwarden {
                reverse_proxy miasma.${domain}:5902
            }

            @homepage host homepage.${domain}
            handle @homepage {
                forward_auth miasma.${domain}:9091 {
                    uri /api/authz/forward-auth
                    copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
                }

                reverse_proxy miasma.${domain}:8082
            }

            @grocy host grocy.${domain} 
            handle @grocy {
                # reverse_proxy lastprism.${domain}:9283
                reverse_proxy 10.10.12.102:9283
            }

            @paperless host paperless.${domain}
            handle @paperless {
                reverse_proxy lastprism.${domain}:28981
            }

            @homebox host homebox.${domain}
            handle @homebox {
                reverse_proxy lastprism.${domain}:7745
            }

            @navidrome host navidrome.${domain} 
            handle @navidrome {
                reverse_proxy lastprism.${domain}:4533
            }

            @sftpgo host sftpgo.${domain} 
            handle @sftpgo {
                reverse_proxy lastprism.${domain}:4856
            }

            @webdav host webdav.${domain} 
            handle @webdav {
                reverse_proxy lastprism.${domain}:9837
            }

            @home-assistant host home-assistant.${domain} 
            handle @home-assistant {
                reverse_proxy lastprism.${domain}:8123
            }

            @zigbee2mqtt host zigbee2mqtt.${domain} 
            handle @zigbee2mqtt {
                reverse_proxy lastprism.${domain}:8080
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
        defaults.server = "https://acme-v02.api.letsencrypt.org/directory";
        # Staging
        # defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";

        certs.${domain} = {
            group = config.services.caddy.group;

            inherit domain;
            extraDomainNames = [ 
                "*.${domain}"
                "*.lastprism.${domain}"
            ];
            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            dnsPropagationCheck = true;
            environmentFile = config.age.secrets.cloudflare-dnsApiToken.path;
        };
    };
}
