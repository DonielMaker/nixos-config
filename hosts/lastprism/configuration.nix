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
        docker
        openssh

        lldap

        ./modules/caddy.nix
        ./modules/authelia.nix
    ];

    # paperless, opencloud, copyparty, radicale, alloy, prometheus,
    networking.firewall.allowedTCPPorts = [ 28981 9200 3923 5232 12345 9090];

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
            donielmaker.passwordFile = "/run/keys/copyparty/don_password";
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
    services.paperless.enable = true;
    services.paperless = {
        address = "0.0.0.0";
        dataDir = "/storage/paperless";

        settings = {
            PAPERLESS_URL = "https://paperless.thematt.net";
            PAPERLESS_OCR_LANGUAGE = "eng+deu";
            PAPERLESS_TIME_ZONE = "Europe/Berlin";
        };
    };

    # Tika: Ocr?
    services.tika.enable = true;
    services.tika = {
        listenAddress = "0.0.0.0";
        openFirewall = true;
        enableOcr = true;
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
                    disk = "/storage";
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
                        };
                    }
                    {
                        "Authelia" = {
                            description = "Idp manager";
                            href = "https://authelia.thematt.net";
                        };
                    }
                    {
                        "Lastprism" = {
                            description = "The Proxmox Lastprism Server";
                            href = "https://proxmox.lastprism.thematt.net";
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
                        };
                    }
                    {
                        "Paperless" = {
                            description = "Document server";
                            href = "https://paperless.thematt.net";
                        };
                    }
                    {
                        "Copyparty" = {
                            description = "Fileserver";
                            href = "https://copyparty.thematt.net";
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

    services.alloy.enable = true;
    services.alloy.extraFlags = [
        "--server.http.listen-addr=0.0.0.0:12345" 
    ];
    environment.etc."alloy/config.alloy".text = ''
        prometheus.exporter.unix "metrics" {
            disable_collectors = ["ipvs", "btrfs", "infiniband", "xfs", "zfs"]
            enable_collectors = ["meminfo"]

            filesystem {
                fs_types_exclude     = "^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|tmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$"
                    mount_points_exclude = "^/(dev|proc|run/credentials/.+|sys|var/lib/docker/.+)($|/)"
                    mount_timeout        = "5s"
            }

            netclass {
                ignored_devices = "^(veth.*|cali.*|[a-f0-9]{15})$"
            }

            netdev {
                device_exclude = "^(veth.*|cali.*|[a-f0-9]{15})$"
            }
        }

        discovery.relabel "metrics" {
            targets = prometheus.exporter.unix.metrics.targets

            rule {
                target_label = "instance"
                    replacement  = constants.hostname
            }

            rule {
                target_label = "job"
                    replacement = string.format("%s-metrics", constants.hostname)
            }
        }

        prometheus.scrape "metrics" {
            scrape_interval = "15s"
            targets = discovery.relabel.metrics.output
            forward_to = [prometheus.remote_write.metrics.receiver]
        }

        prometheus.remote_write "metrics" {
            endpoint {
                url = "http://localhost:9090/api/v1/write"
            }
        }
    '';

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
