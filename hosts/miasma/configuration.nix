{ config, inputs, pkgs, system, domain, ...}:

{

    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default

        systemd-boot
        networking
        settings
        user
        openssh

        alloy
        ./modules/caddy.nix
        ./modules/authelia.nix
    ];

    # prometheus, uptime-kuma, authelia, bind, lldap-web, lldap-ldap
    networking.firewall.allowedTCPPorts = [ 9090 3001 9091  17170 3890 ];
    networking.firewall.allowedUDPPorts = [ 53 ];

    age.secrets = let

        authelia = {
            mode = "440";
            owner = config.services.authelia.instances.main.user;
            group = config.services.authelia.instances.main.group;
        };

    in

    {
        jwtSecret = {
            inherit (authelia) mode owner group;
            file = ./secrets/authelia/jwtSecret.age;
        };

        storageEncryptionKey = {
            inherit (authelia) mode owner group;
            file = ./secrets/authelia/storageEncryptionKey.age;
        };

        sessionSecret = {
            inherit (authelia) mode owner group;
            file = ./secrets/authelia/sessionSecret.age;
        };

        autheliaLldapPassword = {
            inherit (authelia) mode owner group;
            file = ./secrets/authelia/autheliaLldapPassword.age;
        };

        autheliaJwksKey = {
            inherit (authelia) mode owner group;
            file = ./secrets/authelia/autheliaJwksKey.age;
        };

        cloudflareDnsApiToken.file = ./secrets/cloudflareDnsApiToken.age;
    };

    services.lldap.enable = true;
    services.lldap.settings.ldap_base_dn = "dc=thematt,dc=net";
    # User does no longer exist
    services.lldap.settings.ldap_user_pass = "blablabla";
    services.lldap.silenceForceUserPassResetWarning = true;

    # Uptime Kuma: Healthcheck on your services
    services.uptime-kuma.enable = true;
    services.uptime-kuma.settings = {
        HOST = "0.0.0.0";
    };
    
    services.bind.enable = true;
    services.bind = {
        forwarders = [ "1.1.1.1" "1.0.0.1" "9.9.9.9" "8.8.8.8" ]; 
        cacheNetworks = [ "10.20.0.0/16" "10.10.0.0/16" ];
        zones = {
            "${domain}" = {
                master = true;
                file = pkgs.writeText "${domain}.zone" ''
$TTL 2d    ; default TTL for zone

$ORIGIN ${domain}.

; Start of Authority RR defining the key characteristics of the zone (domain)

@                   IN      SOA   ns.${domain}. daniel.schmidt0204.gmail.com (

            2025111000; serial number
            12h        ; refresh
            15m        ; update retry
            3w         ; expiry
            2h         ; minimum
)

                    IN      NS      ns.${domain}.

ns                  IN      A       10.10.12.10

nixos.lastprism     IN      A       10.10.12.11

lastprism           IN      A       10.10.12.12

miasma              IN      A       10.10.12.10

*                   IN      CNAME   miasma.${domain}.

*.lastprism         IN      CNAME   miasma.${domain}.
                '';
            };
        };
    };

    # Homepage: a Dashboard for all your needs
    services.homepage-dashboard.enable = true;
    services.homepage-dashboard = {
        openFirewall = true;
        allowedHosts = "homepage.${domain}";
        widgets = [
            {
                resources = {
                    cpu = true;
                    uptime = true;
                    units = "metric";
                    memory = true;
                };
            }
            {
                search = {
                    provider = "duckduckgo";
                    target = "_blank";
                    focus = "true";
                };
            }
            {
                greeting = {
                    text_size = "x1";
                    text = "Hello you motherfucker";
                };
            }
        ];
        services = [
            {
                "Management/Authentication" = [
                    {
                        "Lldap" = {
                            description = "Ldap server written in rust";
                            href = "https://lldap.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/lldap-light.svg";
                        };
                    }
                    {
                        "Authelia" = {
                            description = "Idp manager";
                            href = "https://authelia.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/authelia.svg";
                        };
                    }
                    {
                        "Lastprism" = {
                            description = "The Proxmox Lastprism Server";
                            href = "https://proxmox.lastprism.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/proxmox.svg";
                        };
                    }
                    {
                        "Grafana" = {
                            description = "Metrics and Logs visualization";
                            href = "https://grafana.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/grafana.svg";
                        };
                    }
                    {
                        "Uptime Kuma" = {
                            description = "Check uptime of services";
                            href = "https://uptime.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/uptime-kuma.svg";
                            widget = {
                                type = "uptimekuma";
                                url = "http://miasma.${domain}:3001";
                                slug = "homepage";
                            };
                        };
                    }
                    {
                        "Fritz!Box" = {
                            description = "Fritz Box Router";
                            href = "http://192.168.0.1";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/fritz.svg";
                        };
                    }
                ];
            }
            {
                "Services" = [
                    {
                        "Navidrome" = {
                            description = "Music server";
                            href = "https://navidrome.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/navidrome.svg";
                        };
                    }
                    {
                        "Paperless" = {
                            description = "Document server";
                            href = "https://paperless.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/paperless-ngx.svg";
                        };
                    }
                    {
                        "Copyparty" = {
                            description = "Fileserver";
                            href = "https://copyparty.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/copyparty.svg";
                        };
                    }
                    {
                        "Radicale" = {
                            description = "CalDav/CardDav Server";
                            href = "https://radicale.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/radicale.svg";
                        };
                    }
                    {
                        "Homeassistant" = {
                            description = "Home Automation Server";
                            href = "https://home-assistant.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/home-assistant-light.svg";
                        };
                    }
                    {
                        "Zigbee2mqtt" = {
                            description = "Connection Between Zigbee and Mqtt";
                            href = "https://zigbee2mqtt.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/zigbee2mqtt.svg";
                        };
                    }
                    {
                        "Trilium" = {
                            description = "Note-taking Server";
                            href = "https://trilium.${domain}";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons@master/svg/trilium-notes.svg";
                        };
                    }
                ];
            }
        ];
    };

    services.grafana.enable = true;
    services.grafana.settings = {
        server = {
            http_addr = "0.0.0.0";
            http_port = 6778;
            root_url = "https://grafana.${domain}";
        };

        "auth.generic_oauth" = {
            enabled = true;
            name = "Authelia";
            icon = "signin";
            client_id = "grafana";
            client_secret = "28FH7GuRhs1K3U2NYOnt3qr11AcEthbljKNP9GEOfcMtaeK0bEW7ZGCWSmku6bUL";
            scopes = "openid profile email groups";
            empty_scopes = false;
            auth_url = "https://authelia.${domain}/api/oidc/authorization";
            token_url = "https://authelia.${domain}/api/oidc/token";
            api_url = "https://authelia.${domain}/api/oidc/userinfo";
            login_attribute_path = "preferred_username";
            groups_attribute_path = "groups";
            name_attribute_path = "name";
            use_pkce = true;
            signout_redirect_url = "https://authelia.${domain}";
            role_attribute_path = "contains(groups[*], 'Grafana_Admin') && 'Admin' || contains(groups[*], 'Grafana_Editor') && 'Editor' || 'Viewer'";
        };
    };

    services.prometheus.enable = true;
    services.prometheus.extraFlags = [ "--web.enable-remote-write-receiver" ];
    services.prometheus = {
        webExternalUrl = "https://prometheus.${domain}";
        port = 9090;
    };

    nix.settings.trusted-users = [ "donielmaker" ];

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default

        vim
        git
    ];

    system.stateVersion = "25.05"; # Just don't
}
