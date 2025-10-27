{ inputs, pkgs, system, config, ...}:

{

    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default
        inputs.copyparty.nixosModules.default

        bootloader
        networking
        settings
        user
        openssh

        lldap
        alloy
        ./modules/caddy.nix
        ./modules/authelia.nix
    ];

    # paperless, opencloud, copyparty, radicale, prometheus, homeassistant, zigbee2mqtt, mosquitto
    networking.firewall.allowedTCPPorts = [ 28981 9200 3923 5232 9090 8123 8080 1883];

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

    nixpkgs.overlays = [
        inputs.copyparty.overlays.default
    ];

    # Copyparty: WebDav Fileserver with great performance
    services.copyparty.enable = true;
    services.copyparty = {
        settings = {
            i = "0.0.0.0";
            z = true;
            e2dsa = true;
            e2ts = true;
        };

        accounts = {
            donielmaker.passwordFile = "${pkgs.writeText "donielmaker" "Changeme"}";
        };

        volumes = {
            "/" = {
                path = "/storage/copyparty";
                access.rwmda = "donielmaker";
            };
        };
    };

    # Navidrome: A Music server which uses the subsonic protocol to send content to clients
    services.navidrome.enable = true;
    services.navidrome.openFirewall = true;
    services.navidrome.settings = { 
        Address = "0.0.0.0";
        MusicFolder = "/storage/music"; 
    };

    # Radicale: CalDav/CardDav server for syncing calenders and contacts
    services.radicale.enable = true;
    services.radicale.settings = {
        server.hosts = [ "0.0.0.0:5232" ];
        storage.filesystem_folder = "/storage/radicale";
        auth.type = "ldap";
        auth = {
            ldap_uri = "ldap://nixos.lastprism.thematt.net:3890";
            ldap_base = "dc=thematt,dc=net";
            ldap_reader_dn = "uid=radicale,ou=people,dc=thematt,dc=net";
            ldap_secret = "Changeme";
            ldap_user_attribute = "uid";
            # ldap_secret_file = config.age.secrets.radicale_lldap_pass.path;
            ldap_filter = "(&(objectClass=Person)(uid={0})(memberOf=cn=radicale,ou=groups,dc=thematt,dc=net))";
        };
    };

    # Paperless: A Document server with plenty of features (ocr, file conversion, editing, etc.)
    # services.paperless.enable = true;
    # services.paperless = {
    #     address = "0.0.0.0";
    #     dataDir = "/storage/paperless";
    #
    #     settings = {
    #         PAPERLESS_URL = "https://paperless.thematt.net";
    #         PAPERLESS_OCR_LANGUAGE = "eng+deu";
    #         PAPERLESS_TIME_ZONE = "Europe/Berlin";
    #     };
    # };

    # Tika: Ocr?
    # services.tika.enable = true;
    # services.tika = {
    #     listenAddress = "0.0.0.0";
    #     openFirewall = true;
    #     enableOcr = true;
    # };

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
                    {
                        "Paperless" = {
                            description = "Document server";
                            href = "https://paperless.thematt.net";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/paperless-ngx.svg";
                        };
                    }
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

    # Home-Assistant: Home Automation
    services.home-assistant.enable = true;
    services.home-assistant = {
        extraComponents = [
            # Components required to complete the onboarding
            "analytics"
            "google_translate"
            "met"
            "radio_browser"
            "shopping_list"
            # Recommended for fast zlib compression
            # https://www.home-assistant.io/integrations/isal
            "isal"
            "mqtt"
        ];
        config = {
            # Includes dependencies for a basic setup
            # https://www.home-assistant.io/integrations/default_config/
            default_config = {};
            http = {
                use_x_forwarded_for = true;
                trusted_proxies = [ "10.10.12.3" ];
            };
        };
    };

    # Mosquitto: Mqtt Server
    # Needs authentication currently not usable for prod. Used anyways
    services.mosquitto.enable = true;
    services.mosquitto = {
        listeners = [
            {
                acl = [ "pattern readwrite #" ];
                omitPasswordAuth = true;
                settings.allow_anonymous = true;
            }
        ];
    };

    # Zigbee2mqtt: Connection between Zigbee and Mqtt devices
    services.zigbee2mqtt.enable = true;
    services.zigbee2mqtt = {
        settings = {
            homeassistant.enabled = config.services.home-assistant.enable;
            frontend.enabled = true;
            permit_join = true;
            serial = {
                port = "/dev/ttyUSB0";
            };
        }
        ;
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

    # services.loki.enable = true;
    # services.loki = {
    #     configuration.auth_enabled = false;
    #     configuration.server.http_listen_port = 3100;
    # };

    nix.settings.trusted-users = [ "donielmaker" ];

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default

        vim
        git
    ];

    system.stateVersion = "25.11"; # Just don't
}
