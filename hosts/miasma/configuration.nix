{ inputs, pkgs, system, config, ...}:

{

    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default

        bootloader
        networking
        settings
        user
        openssh

        alloy
        lldap
        ./modules/caddy.nix
        ./modules/authelia.nix
    ];

    # prometheus, uptime-kuma, authelia, bind
    networking.firewall.allowedTCPPorts = [ 9090 3001 9091];
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

    # Uptime Kuma: Healthcheck on your services
    services.uptime-kuma.enable = true;
    services.uptime-kuma.settings = {
        HOST = "0.0.0.0";
    };
    
    services.bind.enable = true;
    services.bind = {
        forwarders = [ "1.1.1.1" "1.0.0.1" "9.9.9.9" "8.8.8.8" ]; 
        zones = {
            "thematt.net" = {
                master = true;
                file = pkgs.writeText "thematt-net.zone" ''
$TTL 2d    ; default TTL for zone

$ORIGIN thematt.net.

; Start of Authority RR defining the key characteristics of the zone (domain)

@                   IN      SOA   ns.thematt.net. daniel.schmidt0204.gmail.com (

            2025111000; serial number
            12h        ; refresh
            15m        ; update retry
            3w         ; expiry
            2h         ; minimum
)

                    IN      NS      ns.thematt.net.

ns                  IN      A       10.10.12.10

nixos.lastprism     IN      A       10.10.12.11

lastprism           IN      A       10.10.12.12

miasma              IN      A       10.10.12.10

*                   IN      CNAME   miasma.thematt.net.
                '';
            };
        };
    };

    # Homepage: a Dashboard for all your needs
    services.homepage-dashboard.enable = true;
    services.homepage-dashboard = {
        openFirewall = true;
        allowedHosts = "homepage.thematt.net";
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
                            href = "https://lldap.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/lldap-light.svg";
                        };
                    }
                    {
                        "Authelia" = {
                            description = "Idp manager";
                            href = "https://authelia.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/authelia.svg";
                        };
                    }
                    {
                        "Lastprism" = {
                            description = "The Proxmox Lastprism Server";
                            href = "https://proxmox.lastprism.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/proxmox.svg";
                        };
                    }
                    {
                        "Grafana" = {
                            description = "Metrics and Logs visualization";
                            href = "https://grafana.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/grafana.svg";
                        };
                    }
                    {
                        "Uptime Kuma" = {
                            description = "Check uptime of services";
                            href = "https://uptime.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/uptime-kuma.svg";
                            widget = {
                                type = "uptimekuma";
                                url = "http://miasma.thematt.net:3001";
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
                            href = "https://navidrome.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/navidrome.svg";
                        };
                    }
                    # {
                    #     "Paperless" = {
                    #         description = "Document server";
                    #         href = "https://paperless.thematt.net";
                    #         icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/paperless-ngx.svg";
                    #     };
                    # }
                    {
                        "Copyparty" = {
                            description = "Fileserver";
                            href = "https://copyparty.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/copyparty.svg";
                        };
                    }
                    {
                        "Radicale" = {
                            description = "CalDav/CardDav Server";
                            href = "https://radicale.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/radicale.svg";
                        };
                    }
                    {
                        "Homeassistant" = {
                            description = "Home Automation Server";
                            href = "https://home-assistant.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/home-assistant-light.svg";
                        };
                    }
                    {
                        "Zigbee2mqtt" = {
                            description = "Connection Between Zigbee and Mqtt";
                            href = "https://zigbee2mqtt.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/zigbee2mqtt.svg";
                        };
                    }
                ];
            }
        ];
    };

    services.grafana.enable = true;
    services.grafana.settings = {
        server = {
            # Listening Address
            http_addr = "0.0.0.0";
            # and Port
            http_port = 6778;
            # Grafana needs to know on which domain and URL it's running
            root_url = "https://grafana.thematt.net";
        };
    };

    services.prometheus.enable = true;
    services.prometheus.extraFlags = [ "--web.enable-remote-write-receiver" ];
    services.prometheus = {
        webExternalUrl = "https://prometheus.thematt.net";
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
