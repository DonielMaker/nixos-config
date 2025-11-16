{ inputs, pkgs, system, username, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default

        # System
        bootloader
        networking
        settings
        user

        openssh

        ./modules/caddy.nix
    ];

    # erpnext
    networking.firewall.allowedTCPPorts = [ 8080 ];
    networking.firewall.allowedUDPPorts = [ 53 ];

    age.secrets = {
        cloudflareDnsApiToken.file = ./secrets/cloudflareDnsApiToken.age;
    };

    users.users.${username}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwnQCbrIxOgzRpoEYyb/SaoDhM5i93wWJ8biH/f8ygT deuyanon@SPC-01"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILkeKH+HNssMqFFvlRcTPy/AQnYp3jdsGj0UJ8KbMOyG deuyanon@mpc-01"
    ];

    services.homepage-dashboard.enable = true;
    services.homepage-dashboard = {
        openFirewall = true;
        allowedHosts = "homepage.soluttech.uk";
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
                    # {
                    #     "Lldap" = {
                    #         description = "Ldap server written in rust";
                    #         href = "https://lldap.thematt.net";
                    #         icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/lldap-light.svg";
                    #     };
                    # }
                    # {
                    #     "Authelia" = {
                    #         description = "Idp manager";
                    #         href = "https://authelia.thematt.net";
                    #         icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/authelia.svg";
                    #     };
                    # }
                    {
                        "srv-mx-01" = {
                            description = "Proxmox Server";
                            href = "https://srv-mx-01.soluttech.uk";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/proxmox.svg";
                        };
                    }
                    # {
                    #     "Grafana" = {
                    #         description = "Metrics and Logs visualization";
                    #         href = "https://grafana.thematt.net";
                    #         icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/grafana.svg";
                    #     };
                    # }
                    {
                        "Uptime Kuma" = {
                            description = "Check uptime of services";
                            href = "https://uptime.soluttech.uk";
                            icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/uptime-kuma.svg";
                            # widget = {
                            #     type = "uptimekuma";
                            #     url = "http://miasma.thematt.net:3001";
                            #     slug = "homepage";
                            # };
                        };
                    }
                    # {
                    #     "Fritz!Box" = {
                    #         description = "Fritz Box Router";
                    #         href = "http://192.168.0.1";
                    #         icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/fritz.svg";
                    #     };
                    # }
                ];
            }
            {
                "Services" = [
                    # {
                    #     "Paperless" = {
                    #         description = "Document server";
                    #         href = "https://paperless.thematt.net";
                    #         icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/paperless-ngx.svg";
                    #     };
                    # }
                    # {
                    #     "Copyparty" = {
                    #         description = "Fileserver";
                    #         href = "https://copyparty.thematt.net";
                    #         icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/copyparty.svg";
                    #     };
                    # }
                    # {
                    #     "Radicale" = {
                    #         description = "CalDav/CardDav Server";
                    #         href = "https://radicale.thematt.net";
                    #         icon = "https://cdn.jsdelivr.net/gh/selfhst/icons/svg/radicale.svg";
                    #     };
                    # }
                ];
            }
        ];
    };

    services.uptime-kuma.enable = true;
    services.uptime-kuma.settings = {
        HOST = "0.0.0.0";
    };

    services.bind.enable = true;
    services.bind = {
        forwarders = [ "1.1.1.1" "1.0.0.1" "9.9.9.9" "8.8.8.8" ]; 
        cacheNetworks = [ "10.20.0.0/16" "10.10.0.0/16" ];
        zones = {
            "soluttech.uk" = {
                master = true;
                file = pkgs.writeText "soluttech-uk.zone" ''
$TTL 2d    ; default TTL for zone

$ORIGIN soluttech.uk.

; Start of Authority RR defining the key characteristics of the zone (domain)

@                   IN      SOA   ns.soluttech.uk. solut-adminstrator@proton.me (

            2025111000; serial number
            12h        ; refresh
            15m        ; update retry
            3w         ; expiry
            2h         ; minimum
)

                    IN      NS      ns.soluttech.uk.

ns                  IN      A       10.10.110.10

srv-mx-02           IN      A       10.10.110.10

srv-mx-01           IN      A       10.10.110.12

*                   IN      CNAME   srv-mx-02.soluttech.uk.
                '';
            };
        };
    };

    nix.settings.trusted-users = [ "donielmaker" "deuyanon" "solut" ];


    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default

        vim
        git
    ];

    system.stateVersion = "25.05"; # Just don't
}
