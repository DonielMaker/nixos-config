{config, ...}:

{
    networking.firewall.allowedTCPPorts = [ 22 80 443 ];

    services.traefik.enable = true;
    services.traefik.staticConfigOptions = {
        api = {
            dashboard = true;
        };

        log = {
            level = "WARN";
            filepath = "${config.services.traefik.dataDir}/traefik.log";
            format = "json";
        };

        entryPoints = {
            http = {
               address = ":80";
               # http = {
               #     redirections.entryPoint.to = "https";
               #     redirections.entryPoint.scheme = "https";
               # };
            };

            https = {
                address = ":443";
                # http.tls.certResolver = "cloudflare";
            };
        };

        serversTransport.insecureSkipVerify = true;

        certificatesResolvers.cloudflare.acme = {
           email = "daniel.schmidt0204@gmail.com";
           storage = "${config.services.traefik.dataDir}/acme.json";
           #caServer = "https://acme-v02.api.letsencrypt.org/directory"; # prod
           caServer = "https://acme-staging-v02.api.letsencrypt.org/directory"; # staging
           dnsChallenge = {
               provider = "cloudflare";
               resolvers = [
                   "1.1.1.1:53"
                   "1.0.0.1:53"
               ];
           };
        };
    };

    services.traefik.dynamicConfigOptions = {
        http = {
            routers = {
                traefik = {
                    rule = "Host(`traefik.test.thematt.net`)";
                    service = "api@internal";
                };
                sf = {
                    rule = "Host(`seafile.test.thematt.net`)";
                    service = "sf";
                };
            };
            services = {
                sf.loadBalancer.servers = [{url = "http://10.10.12.14:8000";}];
            };
        };
    };      
}

      #   # tls config
      # - "traefik.http.routes.traefik.tls=true"
      # - "traefik.http.routers.traefik.tls.certresolver=cloudflare"
      #
      # - "traefik.http.routers.traefik.tls.domains[0].main=thematt.net"
      # - "traefik.http.routers.traefik.tls.domains[0].sans=*.thematt.net"
      #
      # - "traefik.http.routers.traefik.tls.domains[1].main=vilethorn.thematt.net"
      # - "traefik.http.routers.traefik.tls.domains[1].sans=*.vilethorn.thematt.net"
      #
      # - "traefik.http.routers.traefik.tls.domains[2].main=lastprism.thematt.net"
      # - "traefik.http.routers.traefik.tls.domains[2].sans=*.lastprism.thematt.net" 
