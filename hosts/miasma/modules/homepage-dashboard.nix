{ config, lib, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.homepage-dashboard;
    domain = config.networking.domain;
in

{
    options.modules.server.homepage-dashboard.enable = mkEnableOption "Enable Homepage-Dashboard";

    config = mkIf cfg.enable {

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

            services = [
                {
                    "Management/Authentication" = [
                        {
                            "Authelia" = {
                                description = "IdP Manager";
                                icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/authelia.svg";
                                href = "https://authelia.${domain}";
                                siteMonitor = "http://miasma.${domain}:9091";
                            };
                        }
                        {
                            "Apathanull" = {
                                description = "The Proxmox Lastprism Server";
                                icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/proxmox.svg";
                                href = "https://proxmox.${domain}";
                                siteMonitor = "https://apathanull.${domain}:8006";
                            };
                        }
                        {
                            "Technitium" = {
                                description = "DNS/DHCP Server";
                                icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/technitium.svg";
                                href = "https://technitium.${domain}";
                                siteMonitor = "http://miasma.${domain}:5380";
                            };
                        }
                        {
                            "Fritz!Box" = {
                                description = "Fritz Box Router";
                                icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/fritz.svg";
                                href = "http://192.168.0.1";
                            };
                        }
                    ];
                }
                {
                    "Services" = [
                        {
                            "Vaultwarden" = {
                                description = "Passwordmanager";
                                icon = "https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/vaultwarden-light.svg";
                                href = "https://vaultwarden.${domain}";
                                siteMonitor = "http://miasma.${domain}:5902";
                            };
                        }
                        {
                            "Homebox" = {
                                description = "Inventory Management";
                                icon = "https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/homebox.svg";
                                href = "https://homebox.${domain}";
                                siteMonitor = "http://lastprism.${domain}:7745";
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
                            "Navidrome" = {
                                description = "Music server";
                                icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/navidrome.svg";
                                href = "https://navidrome.${domain}";
                                siteMonitor = "http://lastprism.${domain}:4533";
                            };
                        }
                        {
                            "SFTPGo" = {
                                description = "Fileserver";
                                icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/sftpgo.svg";
                                href = "https://sftpgo.${domain}";
                                siteMonitor = "http://lastprism.${domain}:4856";
                            };
                        }
                        {
                            "Homeassistant" = {
                                description = "Home Automation Server";
                                icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/home-assistant-light.svg";
                                href = "https://home-assistant.${domain}";
                                siteMonitor = "http://10.10.12.101:8123";
                            };
                        }
                    ];
                }
            ];
        };
    };
}
