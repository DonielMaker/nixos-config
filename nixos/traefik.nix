{...}:

{
   networking.firewall.allowedTCPPorts = [80 443];

    services.traefik.enable = true;
    #services.traefik.staticConfigFile = ./traefik.toml;
    services.traefik.staticConfigOptions = {
        api = {
            dashboard = true;
            debug = false;
        };

        entryPoints = {
            #http = {
            #    address = 80;
            #    http = {
            #        redirections.entryPoint.to = "https";
            #        redirections.entryPoint.scheme = "https";
            #    };
            #};

            https.address = ":443";

            #serversTransport.insecureSkipVerify = true;

            #certificatesResolvers."cloudflare".acme = {
            #    email = "daniel.schmidt0204@gmail.com";
            #    storage = "acme.json";
            #    #caServer = "https://acme-v02.api.letsencrypt.org/directory"; # prod
            #    caServer = "https://acme-staging-v02.api.letsencrypt.org/directory"; # staging
            #        dnsChallenge = {
            #            provider = "cloudflare";
            #            resolvers = [
            #                "1.1.1.1:53"
            #                    "1.0.0.1:53"
            #            ];
            #        };
            #};
        };
    };
    services.traefik.environmentFiles = [
	/home/donielmaker/.config/nixos-config/nixos/.env
    ];
    services.traefik.dynamicConfigOptions = {
        http = {
            routers = {
                traefik = {
                    entrypoints = "https";
                    rule = "Host(`traefik.test.thematt.net`)";
                    service = "api@internal";
                };
            };

            services
        };

      #   # tls config
      # - "traefik.http.routers.traefik.tls=true"
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
    };      
}
