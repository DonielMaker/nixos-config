{config, lib, ...}:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.caddy;
    domain = config.networking.domain;
in

{
    options.modules.server.caddy.enable = mkEnableOption "Enable Caddy";

    config = mkIf cfg.enable {
        networking.firewall.allowedTCPPorts = [ 80 443 ];

        # Caddy: Simple but featureful Reverse Proxy
        services.caddy.enable = true;
        services.caddy.extraConfig = ''

            # === TLS ===
            *.${domain} {
                tls /var/lib/acme/${domain}/cert.pem /var/lib/acme/${domain}/key.pem {
                    protocols tls1.3
                }
            }

            # === Miasma ===
            authelia.${domain} {
                reverse_proxy miasma.${domain}:9091 
            }

            vaultwarden.${domain} {
                reverse_proxy miasma.${domain}:5902 
            }

            technitium.${domain} {
                reverse_proxy miasma.${domain}:5380 
            }

            grafana.${domain} {
                reverse_proxy miasma.${domain}:6778
            }

            alertmanager.${domain} {
                reverse_proxy miasma.${domain}:9093
            }

            prometheus.${domain} {
                reverse_proxy miasma.${domain}:9090
            }

            homepage.${domain} {
                forward_auth miasma.${domain}:9091 {
                    uri /api/authz/forward-auth
                    copy_headers Remote-User Remote-Groups Remote-Email Remote-Name
                }

                reverse_proxy miasma.${domain}:8082
            }
            
            # === Lastprism ===
            paperless.${domain} {
                reverse_proxy lastprism.${domain}:28981 
            }
            
            homebox.${domain} {
                reverse_proxy lastprism.${domain}:7745 
            }
            
            navidrome.${domain} {
                reverse_proxy lastprism.${domain}:4533 
            }

            sftpgo.${domain} {
                reverse_proxy lastprism.${domain}:4856 
            }

            webdav.${domain} {
                reverse_proxy lastprism.${domain}:9837 
            }

            # === Misc ===
            home-assistant.${domain} {
                reverse_proxy http://10.10.12.101:8123 {
                    header_up Host {host}
                    header_up X-Real-IP {remote_host}
                    header_up X-Forwarded-For {remote_host}
                    header_up X-Forwarded-Proto {scheme}
                }
            }
            
            proxmox.${domain} {
                reverse_proxy apathanull.${domain}:8006 {
                    transport http { tls_insecure_skip_verify }
                }
            }
        '';

        users.groups.certs.members = [ config.services.caddy.user ];
        security.acme = {
            acceptTerms = true;
            defaults.email = "daniel.schmidt0204@gmail.com";
            defaults.server = "https://acme-v02.api.letsencrypt.org/directory";
            # defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory"; # Staging

            certs.${domain} = {
                group = config.users.groups.certs.name;

                inherit domain;
                extraDomainNames = [ "*.${domain}" ];
                dnsProvider = "cloudflare";
                dnsResolver = "1.1.1.1:53";
                dnsPropagationCheck = true;
                environmentFile = config.age.secrets.cloudflare-dnsApiToken.path;
            };
        };
    };
}
