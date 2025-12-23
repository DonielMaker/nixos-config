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

    # prometheus, authelia, lldap-web, lldap-ldap, vaultwarden
    networking.firewall.allowedTCPPorts = [ 9090 9091 17170 3890 5902];
    # bind9
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

    # Vaultwarden: Passwordmanager
    services.vaultwarden.enable = true;
    services.vaultwarden = {
        backupDir = "/storage/vaultwarden";
        config = {
            DOMAIN = "https://vaultwarden.${domain}";
            ADMIN_TOKEN = "$argon2id$v=19$m=65536,t=3,p=4$PuLNkQoWqh2KK6oTiS13zA$jODU+1C0V9/dEMmMbmtyRtEFXgwAkBfTb36s848IUzA";
            ROCKET_ADDRESS = "0.0.0.0";
            ROCKET_PORT = 5902;
            # HaveIBeenPwned Api Key
            HIBP_API_KEY = "";
            TRASH_AUTO_DELETE_DAYS = 30;
            SIGNUPS_ALLOWED = false;
            IP_HEADER = "X-Forwarded-For";
            # Do we need this?
            PASSWORD_HINTS_ALLOWED = false;
        };
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

proxmox.lastprism             IN      A       10.10.12.12

lastprism                   IN      A       10.10.12.11

miasma                   IN      A       10.10.12.10

*                   IN      CNAME   miasma.${domain}.
                '';
            };
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
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/lldap-light.svg";
                            href = "https://lldap.${domain}";
                            siteMonitor = "http://miasma.${domain}:17170";
                        };
                    }
                    {
                        "Authelia" = {
                            description = "Idp manager";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/authelia.svg";
                            href = "https://authelia.${domain}";
                            siteMonitor = "http://miasma.${domain}:9091";
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
                        "Radicale" = {
                            description = "CalDav/CardDav Server";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/radicale.svg";
                            href = "https://radicale.${domain}";
                            siteMonitor = "http://lastprism.${domain}:5232";
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
                    {
                        "Trilium" = {
                            description = "Note-taking Server";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons@master/svg/trilium-notes.svg";
                            href = "https://trilium.${domain}";
                            siteMonitor = "http://lastprism.${domain}:8965";
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
