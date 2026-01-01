{config, inputs, pkgs, username, domain, arch, ...}:

{

    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.disko.nixosModules.disko
        inputs.ragenix.nixosModules.default
        inputs.copyparty.nixosModules.default

        systemd-boot
        networking
        settings
        user
        openssh
        hyprland

        alloy
    ];

    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

    # copyparty, radicale, homeassistant, zigbee2mqtt, mosquitto, paperless, outline
    networking.firewall.allowedTCPPorts = [ 3923 5232 8123 8080 1883 28981 2920 ];

    powerManagement.powertop.enable = true;

    users.users.${username}.extraGroups = [ "media" ];
    users.groups.media = {};

    # Should these be hardcoded or via config.services.copyparty.user, etc.?
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

        outline = {
            mode = "440";
            owner = config.services.outline.user;
            group = config.services.outline.group;
        };
    in

    {
        copyparty-donielmaker-password = {
            inherit (copyparty) mode owner group;
            file = ./secrets/copyparty/copyparty-donielmaker-password.age;
        };

        outline-secretKey = {
            inherit (outline) mode owner group;
            file = ./secrets/outline/secretKey.age;
        };

        outline-utilsSecret = {
            inherit (outline) mode owner group;
            file = ./secrets/outline/utilsSecret.age;
        };

        outline-clientSecret = {
            inherit (outline) mode owner group;
            file = ./secrets/outline/clientSecret.age;
        };
    };

    # Outline: Note-Taking Server
    services.outline.enable = true;
    systemd.services.outline.environment.OIDC_LOGOUT_URI = "https://homepage.${domain}";
    services.outline = {
        secretKeyFile = config.age.secrets.outline-secretKey.path;
        utilsSecretFile = config.age.secrets.outline-utilsSecret.path;
        port = 2920;
        publicUrl = "https://outline.${domain}";
        forceHttps = false;
        concurrency = 4;
        defaultLanguage = "en_US";
        storage = {
            storageType = "local";
            localRootDir = "/storage/outline";
        };
        oidcAuthentication = {
            clientId = "outline";
            clientSecretFile = config.age.secrets.outline-clientSecret.path;
            authUrl = "https://authelia.${domain}/api/oidc/authorization";
            tokenUrl = "https://authelia.${domain}/api/oidc/token";
            userinfoUrl = "https://authelia.${domain}/api/oidc/userinfo";
            usernameClaim = "preferred_username";
            displayName = "Authelia";
            scopes = [ "openid" "offline_access" "profile" "email" ];
        };
    };

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

    # Radicale: CalDav/CardDav server for syncing calenders and contacts
    services.radicale.enable = true;
    services.radicale.settings = {
        server.hosts = [ "0.0.0.0:5232" ];
        storage.filesystem_folder = "/storage/radicale";
        auth.type = "ldap";
        auth = {
            ldap_uri = "ldap://nixos.lastprism.${domain}:3890";
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
        port = 28981;
        dataDir = "/storage/paperless";

        settings = {
            PAPERLESS_URL = "https://paperless.${domain}";
            PAPERLESS_OCR_LANGUAGE = "eng+deu";
            PAPERLESS_TIME_ZONE = "Europe/Berlin";
            PAPERLESS_TRUSTED_PROXIES = "10.10.12.0/24";
            PAPERLESS_USE_X_FORWARDED_HOST = true;
            PAPERLESS_USE_X_FORWARDED_PORT = true;
            PAPERLESS_LOGOUT_REDIRECT_URL = "https://homepage.${domain}";

            # SSO
            PAPERLESS_SOCIAL_AUTO_SIGNUP = true;
            PAPERLESS_DISABLE_REGULAR_LOGIN = true;
            PAPERLESS_REDIRECT_LOGIN_TO_SSO = true;
            PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
            # TODO: This secrets needs to be secured
            PAPERLESS_SOCIALACCOUNT_PROVIDERS= ''
{
    "openid_connect": {
        "SCOPE":["openid", "profile", "email"],
        "OAUTH_PKCE_ENABLED": true,
        "APPS": [
            {
                "provider_id": "authelia",
                "name": "Authelia",
                "client_id": "paperless",
                "secret": "SE9kT540KNYhaXYxhd7ymQN7OLarVcdWC5BIZKORgbiJSDcj1qDiMnMzFGSPsysh",
                "settings": {
                    "server_url":"https://authelia.thematt.net/.well-known/openid-configuration",
                    "token_auth_method": "client_secret_basic"
                }
            }
        ]
    }
}'';
        };
    };

    # Tika: Ocr?
    # services.tika.enable = true;
    # services.tika = {
    #     listenAddress = "0.0.0.0";
    #     openFirewall = true;
    #     enableOcr = true;
    # };

    # Home-Assistant: Home Automation
    services.home-assistant.enable = true;
    services.home-assistant = {
        extraComponents = [
            # Components required to complete the onboarding
            "analytics"
            "met"
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
                # Why Can't this be dns?
                trusted_proxies = [ "10.10.12.10" ];
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

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${arch}.default

        vim
        git
    ];

    system.stateVersion = "25.11"; # Just don't
}
