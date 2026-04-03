{config, inputs, pkgs, ...}:

{

    imports = [
        ./hardware-configuration.nix
        ./disko.nix
        inputs.copyparty.nixosModules.default
        ./modules/home-assistant.nix
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

    networking.firewall.allowedTCPPorts = [ 
        3923 # copyparty
        8123 # homeassistant
        8080 # zigbee2mqtt
        1883 # mosquitto
        28981 # paperless
        7745 # homebox
        80 443 # inventree
        9987 30033 # tsserver
    ];

    users.users.${config.modules.system.username}.extraGroups = [ "media" ];
    users.groups.media = {};

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
        };
    };


    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default

        vim
        git
    ];

    system.stateVersion = "25.11"; # Just don't
}
