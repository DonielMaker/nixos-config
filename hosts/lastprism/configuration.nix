{config, inputs, pkgs, ...}:

{

    imports = [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.copyparty.nixosModules.default
    ];

    modules = {
        system = {
            enable = true;
            hostname = "lastprism";
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

    networking.hostName = config.modules.system.hostname;

    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

    # copyparty, homeassistant, zigbee2mqtt, mosquitto, paperless, apcupsd, homebox
    networking.firewall.allowedTCPPorts = [ 3923 8123 8080 1883 28981 3551 7745 ];

    users.users.${config.modules.system.username}.extraGroups = [ "media" ];
    users.groups.media = {};

    systemd.tmpfiles.rules = [
        "d /storage/media 0770 copyparty media -"
        "d /storage/media/pictures 0770 copyparty media -"
        "d /storage/media/videos 0770 copyparty media -"
        "d /storage/media/music 0770 navidrome media -"
    ];

    age.secrets = let

        copyparty = {
            mode = "440";
            owner = config.services.copyparty.user;
            group = config.services.copyparty.group;
        };

        # outline = {
        #     mode = "440";
        #     owner = config.services.outline.user;
        #     group = config.services.outline.group;
        # };
    in

    {
        copyparty-donielmaker-password = {
            inherit (copyparty) mode owner group;
            file = ./secrets/copyparty/copyparty-donielmaker-password.age;
        };

        # outlineSecretKey = {
        #     inherit (outline) mode owner group;
        #     file = ./secrets/outline/secretKey.age;
        # };

        # outlineUtilsSecret = {
        #     inherit (outline) mode owner group;
        #     file = ./secrets/outline/utilsSecret.age;
        # };

        # outlineClientSecret = {
        #     inherit (outline) mode owner group;
        #     file = ./secrets/outline/clientSecret.age;
        # };

        homebox-envFile.file = ./secrets/homebox-envFile.age;

        mosquitto-iotPassword.file = ./secrets/mosquitto-iotPassword.age;

        paperless-envFile.file = ./secrets/paperless-envFile.age;
    };

    # Outline: Note-Taking Server
    # services.outline.enable = true;
    # systemd.services.outline.environment.OIDC_LOGOUT_URI = "https://homepage.${domain}";
    # services.outline = {
    #     secretKeyFile = config.age.secrets.outlineSecretKey.path;
    #     utilsSecretFile = config.age.secrets.outlineUtilsSecret.path;
    #     port = 2920;
    #     publicUrl = "https://outline.${domain}";
    #     forceHttps = false;
    #     concurrency = 4;
    #     defaultLanguage = "en_US";
    #     storage = {
    #         storageType = "local";
    #         localRootDir = "/storage/outline";
    #     };
    #     oidcAuthentication = {
    #         clientId = "outline";
    #         clientSecretFile = config.age.secrets.outlineClientSecret.path;
    #         authUrl = "https://authelia.${domain}/api/oidc/authorization";
    #         tokenUrl = "https://authelia.${domain}/api/oidc/token";
    #         userinfoUrl = "https://authelia.${domain}/api/oidc/userinfo";
    #         usernameClaim = "preferred_username";
    #         displayName = "Authelia";
    #         scopes = [ "openid" "offline_access" "profile" "email" ];
    #     };
    # };

    services.teamspeak3.enable = true;
    services.teamspeak3 = {
        openFirewall = true;
        openFirewallServerQuery = true;
        dataDir = "/storage/ts";
    };

    services.apcupsd.enable = true;
    services.apcupsd.configText = ''
        UPSCABLE usb
        UPSTYPE usb
        DEVICE
        LOCKFILE /var/lock
        UPSCLASS standalone
        UPSMODE disable
    '';

    # Copyparty: WebDav Fileserver with great performance
    services.copyparty.enable = true;
    services.copyparty = {
        group = "media";
        settings = {
            i = "0.0.0.0";
            z = true;
            e2dsa = true;
            e2ts = true;

            # As of now this does not work since trying to use copyparty outside the browser (file explorer on PC/Smartphone) leads to a https unauthorized? error.
            # idp-h-usr = "x-idp-user";
            # idp-h-grp = "x-idp-group";
            # idp-store = 3;
            xff-src = "10.10.12.0/24";
        };

        accounts = {
            donielmaker.passwordFile = config.age.secrets.copyparty-donielmaker-password.path;
        };

        volumes = {
            "/" = {
                path = "/storage/media";
                access.rwmda = "donielmaker";
                flags.chmod-f = 644;
            };
        };
    };

    # Currently problems regarding inter-subnet access
    # services.printing.enable = true;
    # services.printing = {
    #     listenAddresses = [ "*:631" ];
    #     # allowFrom = [ "10.10.0.0/16" ];
    #     allowFrom = [ "all" ];
    #     browsing = true;
    #     defaultShared = true;
    #     openFirewall = true;
    # };

    # services.avahi.enable = true;
    # services.avahi = {
    #     nssmdns4 = true;
    #     openFirewall = true;
    # };

    # Navidrome: A Music server which uses the subsonic protocol to send content to clients
    services.navidrome.enable = true;
    services.navidrome = {
        openFirewall = true;
        group = "media";
        settings = {
            Address = "0.0.0.0";
            MusicFolder = "/storage/media/music"; 
        };
    };

    # Homebox: Inventory Management for the Home Owner
    services.homebox.enable = true;
    systemd.services.homebox.serviceConfig.EnvironmentFile = config.age.secrets.homebox-envFile.path;
    services.homebox = {
        database.createLocally = true;
        settings = {
            HBOX_MODE = "production";
            HBOX_OPTIONS_CHECK_GITHUB_RELEASE = "false";

            # Directories
            HBOX_STORAGE_CONN_STRING = "file:///storage/homebox";
            HBOX_STORAGE_PREFIX_PATH = "data";
            HOME = "/storage/homebox";
            TMPDIR = "/storage/homebox/tmp";

            # OIDC
            HBOX_OIDC_ENABLED = "true";
            HBOX_OIDC_ISSUER_URL = "https://authentik.thematt.net/application/o/homebox/";
            HBOX_OIDC_CLIENT_ID = "homebox";
            HBOX_OPTIONS_ALLOW_REGISTRATION = "false";
            HBOX_OPTIONS_TRUST_PROXY = "true";
        };
    };

    # Paperless: A Document server with plenty of features (ocr, file conversion, editing, etc.)
    services.paperless.enable = true;
    services.paperless = {
        address = "0.0.0.0";
        port = 28981;
        dataDir = "/storage/paperless";
        configureTika = true;
        environmentFile = config.age.secrets.paperless-envFile.path;

        settings = {
            PAPERLESS_URL = "https://paperless.${config.modules.server.domain}";
            PAPERLESS_OCR_LANGUAGE = "eng+deu";
            PAPERLESS_TIME_ZONE = "Europe/Berlin";
            PAPERLESS_TRUSTED_PROXIES = "10.10.12.0/24";
            PAPERLESS_USE_X_FORWARDED_HOST = true;
            PAPERLESS_USE_X_FORWARDED_PORT = true;

            # SSO
            PAPERLESS_SOCIAL_AUTO_SIGNUP = true;
            PAPERLESS_LOGOUT_REDIRECT_URL = "https://authentik.${config.modules.server.domain}/application/o/paperless/end-session/";
            PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
            # PAPERLESS_SOCIALACCOUNT_PROVIDERS = ''
            #     {
            #       "openid_connect": {
            #         "OAUTH_PKCE_ENABLED": true,
            #         "APPS": [
            #           {
            #             "provider_id": "authentik",
            #             "name": "authentik",
            #             "client_id": "paperless",
            #             "secret": "NnS5IPSsLp3DffKh9sXy5FraH9B16xJl9VK7XaguaPa2U8hHxuryFn1xNPUPFk2qt12wdvKi6NYut9HXD5GD5B2XLHETIvBSXMt62tBswL3dGkZuUQE7bFgptZEaFTaT",
            #             "settings": {
            #               "server_url": "https://authentik.${config.modules.server.domain}/application/o/paperless/.well-known/openid-configuration",
            #               "fetch_userinfo": true
            #             }
            #           }
            #         ],
            #         "SCOPE": ["openid", "profile", "email"]
            #       }
            #     }'';
        };
    };

    # Home-Assistant: Home Automation
    services.home-assistant.enable = true;
    services.home-assistant = {
        extraComponents = [
            "analytics"
            "met"
            "isal"
            "mqtt"
        ];

        customComponents = with pkgs.home-assistant-custom-components; [
            auth_oidc
            prometheus_sensor
        ];

        config = {
            # Includes dependencies for a basic setup
            # https://www.home-assistant.io/integrations/default_config/
            default_config = {};
            homeassistant = {
                name = "Home";
                latitude = "53.00906288742223";
                longitude = "9.060134791016266";
                unit_system = "metric";
                time_zone = "Europe/Berlin";
            };
            http = {
                use_x_forwarded_for = true;
                # Why Can't this be dns?
                trusted_proxies = [ "10.10.12.10" ];
            };
        };
    };

    # Mosquitto: Mqtt Server
    # Needs authentication currently not usable for prod. Used anyways
    services.mosquitto.enable = true;
    services.mosquitto = {
        # listeners = [
        #     {
        #         acl = [ "pattern readwrite #" ];
        #         omitPasswordAuth = true;
        #         settings.allow_anonymous = true;
        #     }
        # ];
        listeners = [
        {  
            users.iot = {
                acl = [
                    "read IoT/device/action"
                    "write IoT/device/observations"
                    "write IoT/device/LW"
                ];
                passwordFile = config.age.secrets.mosquitto-iotPassword.path;
            };
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
            mqtt = {
                server = "mqtt://lastprism.thematt.net:1883";
                user = "iot";
                password = "2nkFzRMG#l4sxXsUrctHQ&%UcD6ZCc&HIG3vMPxmOfX0VIgvY2HeE5m&&eWbXr^T";
            };
        };
    };

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

        vim
        git
    ];

    system.stateVersion = "25.11"; # Just don't
}
