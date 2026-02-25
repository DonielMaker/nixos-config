{config, inputs, pkgs, ...}:

let
    domain = config.modules.server.domain;
in

{

    imports = [ ./hardware-configuration.nix ./disko.nix

        inputs.authentik-nix.nixosModules.default
        ./modules/caddy.nix
    ];

    modules = {
        system = {
            enable = true;
            hostname = "miasma";
            username = "donielmaker";

            user.enable = true;

            systemd-boot.enable = true;

            openssh.enable = true;
        };

        server = {
            enable = true;
            domain = "thematt.net";
            alloy.enable = true;
            qemuGuest.enable = true;
        };
    };

    # prometheus, vaultwarden, authentik
    networking.firewall.allowedTCPPorts = [ 9090 5902 9000];
    # bind
    networking.firewall.allowedUDPPorts = [ 53 ];

    age.secrets = let

        grafana = {
            mode = "440";
            owner = "grafana";
            group = "grafana";
        };
    in

    {
        authentik-environment.file = ./secrets/authentik/secret.env.age;
        authentik-proxyEnvironment.file = ./secrets/authentik/proxy.env.age;

        grafanaClientSecret = {
            inherit (grafana) mode owner group;
            file = ./secrets/grafana/clientSecret.age;
        };

        grafana-secretKey = {
            inherit (grafana) mode owner group;
            file = ./secrets/grafana/secretKey.age;
        };

        newt-secretEnv.file = ./secrets/newt-secret.env.age;

        vaultwardenEnv.file = ./secrets/vaultwarden-env.age;

        cloudflareDnsApiToken.file = ./secrets/cloudflare/dnsApiToken.age;
    };

    services.authentik.enable = true;
    services.authentik = {
        environmentFile = config.age.secrets.authentik-environment.path;
        settings = {
            email = {
                host = "mail.${domain}";
                port = 587;
                username = "admin@${domain}";
                use_tls = true;
                use_ssl = false;
                from = "authentik@${domain}";
            };
            disable_startup_analytics = true;
            avatars = "initials";
        };
    };

    services.authentik-proxy.enable = true;
    services.authentik-proxy.environmentFile = config.age.secrets.authentik-proxyEnvironment.path;

    services.newt.enable = true;
    services.newt = {
        settings.endpoint = "https://pangolin.soluttech.uk";
        environmentFile = config.age.secrets.newt-secretEnv.path;
    };

    # Vaultwarden: Passwordmanager
    services.vaultwarden.enable = true;
    services.vaultwarden = {
        backupDir = "/storage/vaultwarden";
        environmentFile = config.age.secrets.vaultwardenEnv.path;
        config = {
            DOMAIN = "https://vaultwarden.${domain}";
            ADMIN_TOKEN = "$argon2id$v=19$m=65536,t=3,p=4$yw24wHrUcU5jnsLq1wC2zA$EfhTG1MS60r5Gb5D74VUzPo13a//GTFx9wlPSwh1xwQ";
            ROCKET_ADDRESS = "0.0.0.0";
            ROCKET_PORT = 5902;
            # HaveIBeenPwned Api Key
            TRASH_AUTO_DELETE_DAYS = 30;
            SIGNUPS_ALLOWED = false;
            IP_HEADER = "X-Forwarded-For";
            PASSWORD_HINTS_ALLOWED = false;

            SMTP_HOST = "mail.${domain}";
            SMTP_FROM = "vaultwarden@${domain}";
            SMTP_FROM_NAME = "Vaultwarden";
            SMTP_USERNAME = "admin@${domain}";
        };
    };

    services.bind.enable = true;
    services.bind = {
        forwarders = [ "1.1.1.1" "1.0.0.1" "9.9.9.9" "8.8.8.8" ]; 
        cacheNetworks = [ "127.0.0.1" "10.0.0.0/8" ];
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

proxmox.lastprism   IN      A       10.10.12.12

lastprism           IN      A       10.10.12.11

miasma              IN      A       10.10.12.10

vilethorn           IN      A       10.10.90.1              

ark                 IN      A       10.10.12.13

mail                IN      CNAME   eu1.workspace.org.

ts                  IN      CNAME   lastprism.thematt.net.

*                   IN      CNAME   miasma.${domain}.
                '';
            };

            # Empty so it won't be recursed to somewhere else
            "soluttech.uk" = {
                master = true;
                allowQuery = [];
                file = pkgs.writeText "soluttech.uk.zone" ''
$TTL 3600
@   IN  SOA localhost. root.localhost. (
        1
        3600
        600
        604800
        3600 )
IN  NS  localhost.
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
                greeting = {
                    text_size = "x1";
                    text = "Hello you motherfucker";
                };
            }
        ];

        # bookmarks = [
        #     {
        #
        #         "Social Media" = [
        #             {
        #                 "Youtube" = {
        #                     abbr = "YT";
        #                     href = "https://youtube.com";
        #                 };
        #             }
        #         ];
        #     }
        # ];

        services = [
            {
                "Management/Authentication" = [
                    {
                        "Authentik" = {
                            description = "IdP Manager";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/authentik.svg";
                            href = "https://authentik.${domain}";
                            siteMonitor = "http://miasma.${domain}:9000";
                        };
                    }
                    {
                        "Lastprism" = {
                            description = "The Proxmox Lastprism Server";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/proxmox.svg";
                            href = "https://proxmox.${domain}";
                            siteMonitor = "https://proxmox.lastprism.${domain}:8006";
                        };
                    }
                    {
                        "Grafana" = {
                            description = "Metrics and Logs visualization";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/grafana.svg";
                            href = "https://grafana.${domain}";
                            siteMonitor = "http://miasma.${domain}:6778";
                        };
                    }
                    {
                        "Fritz!Box" = {
                            description = "Fritz Box Router";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/fritz.svg";
                            href = "http://192.168.0.1";
                        };
                    }
                    {
                        "APCUPSD" = {
                            description = "UPS Stats";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/apc.svg";
                            widget = {
                                type = "apcups";
                                url = "tcp://lastprism.${domain}:3551";
                            };
                        };
                    }
                ];
            }
            {
                "Services" = [
                    {
                        "Navidrome" = {
                            description = "Music server";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/navidrome.svg";
                            href = "https://navidrome.${domain}";
                            siteMonitor = "http://lastprism.${domain}:4533";
                        };
                    }
                    {
                        "Vaultwarden" = {
                            description = "Passwordmanager";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/vaultwarden-light.svg";
                            href = "https://vaultwarden.${domain}";
                            siteMonitor = "http://miasma.${domain}:5902";
                        };
                    }
                    {
                        "Paperless" = {
                            description = "Document server";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/paperless-ngx.svg";
                            href = "https://paperless.${domain}";
                            siteMonitor = "http://lastprism.${domain}:28981";
                        };
                    }
                    {
                        "Copyparty" = {
                            description = "Fileserver";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/copyparty.svg";
                            href = "https://copyparty.${domain}";
                            siteMonitor = "http://lastprism.${domain}:3923";
                        };
                    }
                    {
                        "Homeassistant" = {
                            description = "Home Automation Server";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/home-assistant-light.svg";
                            href = "https://home-assistant.${domain}";
                            siteMonitor = "http://lastprism.${domain}:8123";
                        };
                    }
                    {
                        "Zigbee2mqtt" = {
                            description = "Connection Between Zigbee and Mqtt";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/zigbee2mqtt.svg";
                            href = "https://zigbee2mqtt.${domain}";
                            siteMonitor = "http://lastprism.${domain}:8080";
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

        security.secret_key = "$__file{${config.age.secrets.grafana-secretKey.path}}";

        "auth.generic_oauth" = {
            enabled = true;
            name = "Authentik";
            icon = "signin";
            client_id = "grafana";
            client_secret = "$__file{${config.age.secrets.grafanaClientSecret.path}}";
            scopes = "openid profile email groups";
            empty_scopes = false;
            auth_url = "https://authentik.${domain}/application/o/authorize/";
            token_url = "https://authentik.${domain}/application/o/token/";
            api_url = "https://authentik.${domain}/application/o/userinfo/";
            login_attribute_path = "preferred_username";
            groups_attribute_path = "groups";
            name_attribute_path = "display_name";
            use_pkce = true;
            signout_redirect_url = "https://homepage.${domain}";
            skip_org_role_sync = true;
        };
    };

    services.prometheus.enable = true;
    services.prometheus.extraFlags = [ "--web.enable-remote-write-receiver" ];
    services.prometheus = {
        webExternalUrl = "https://prometheus.${domain}";
        port = 9090;
        # globalConfig.scrape_interval = "15s";
        # scrapeConfigs = [
        #     {
        #         job_name = "miasma-metrics";
        #         static_configs = [{
        #             targets = [ "miasma.thematt.net:9100"];
        #         }];
        #     } 
        #     # {
        #     #     job_name = "lastprism-metrics";
        #     #     static_configs = [{
        #     #         targets = [ "lastprism.thematt.net:9100"];
        #     #     }];
        #     # } 
        # ];
    };

    # services.prometheus.exporters.node = {
    #     enable = true;
    #     openFirewall = true;
    #     enabledCollectors = [ "systemd" "meminfo" ];
    #     disabledCollectors = [ "ipvs" "btrfs" "infiniband" "xfs" "zfs" ];
    # };

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

        vim
        git
    ];

    system.stateVersion = "25.05"; # Just don't
}
