{config, ...}:

{
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy.enable = true;
    services.caddy.extraConfig = ''
        *.soluttech.uk {
            tls /var/lib/acme/soluttech.uk/cert.pem /var/lib/acme/soluttech.uk/key.pem {
                protocols tls1.3
            }

            # @authelia host authelia.soluttech.uk
            # handle @authelia {
            #     reverse_proxy srv-mx-01.soluttech.uk:9091
            # }

            # @lldap host lldap.soluttech.uk
            # handle @lldap {
            #     reverse_proxy srv-mx-01.soluttech.uk:17170
            # }

            # @copyparty host copyparty.soluttech.uk 
            # handle @copyparty {
            #     reverse_proxy nixos.lastprism.soluttech.uk:3923
            # }

            @homepage host homepage.soluttech.uk
            handle @homepage {
                # forward_auth srv-mx-01.soluttech.uk:9091 {
                #     uri /api/authz/forward-auth
                #     copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
                # }
                reverse_proxy srv-mx-02.soluttech.uk:8082
            }

            @uptime host uptime.soluttech.uk
            handle @uptime {
                # forward_auth srv-mx-01.soluttech.uk:9091 {
                #     uri /api/authz/forward-auth
                #     copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
                # }
                reverse_proxy srv-mx-02.soluttech.uk:3001
            }

            # @radicale host radicale.soluttech.uk 
            # handle @radicale {
            #     reverse_proxy nixos.lastprism.soluttech.uk:5232
            # }

            # @grafana host grafana.soluttech.uk 
            # handle @grafana {
            #     reverse_proxy miasma.soluttech.uk:6778
            # }

            # @prometheus host prometheus.soluttech.uk 
            # handle @prometheus {
            #     reverse_proxy miasma.soluttech.uk:9090
            # }

            @proxmox host proxmox.soluttech.uk 
            handle @proxmox {
                reverse_proxy 10.10.110.100:8006 {
                    transport http {
                        tls_insecure_skip_verify
                    }
                }
            }
        }
    '';

    security.acme = {
        acceptTerms = true;
        defaults.email = "solut-administrator@proton.me";
        # defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
        defaults.server = "https://acme-v02.api.letsencrypt.org/directory";

        certs."soluttech.uk" = {
            group = config.services.caddy.group;

            domain = "soluttech.uk";
            extraDomainNames = [ "*.soluttech.uk" ];
            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            dnsPropagationCheck = true;
            environmentFile = config.age.secrets.cloudflareDnsApiToken.path;
        };
    };
}
