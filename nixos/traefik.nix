{...}:

{
    services.traefik.enable = true;
    services.traefik.staticConfigOptions = {
        api = {
            dashboard = true;
            debug = false;
        };

        entryPoints = {
            http = {
                address = 80;
                http = {
                    redirections.entryPoint.to = "https";
                    redirections.entryPoint.scheme = "https";
                };
            };

            https.adress = 443;

            serversTransport.insecureSkipVerify = true;

            certificatesResolvers.cloudflare.acme = {
                email = "daniel.schmidt0204@gmail.com";
                storage = "acme.json";
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
    };
    # services.traefik.dynamicConfigOptions = {
    #
    # };      
}
