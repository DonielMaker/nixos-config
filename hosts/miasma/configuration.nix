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
        # ./modules/caddy.nix
        # ./modules/authelia.nix
    ];

    # prometheus, uptime-kuma
    networking.firewall.allowedTCPPorts = [ 9090 3001];

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
            file = ./secrets/jwtSecret.age;
        };

        storageEncryptionKey = {
            inherit (authelia) mode owner group;
            file = ./secrets/storageEncryptionKey.age;
        };
        sessionSecret = {
            inherit (authelia) mode owner group;
            file = ./secrets/sessionSecret.age;
        };
        autheliaLldapPassword = {
            inherit (authelia) mode owner group;
            file = ./secrets/autheliaLldapPassword.age;
        };
        autheliaJwksKey = {
            inherit (authelia) mode owner group;
            file = ./secrets/autheliaJwksKey.age;
        };

        cloudflareDnsApiToken.file = ./secrets/cloudflareDnsApiToken.age;
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
                                url = "http://nixos.lastprism.thematt.net:3001";
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

    system.stateVersion = "25.11"; # Just don't
}
