{config, inputs, pkgs, ...}:

{

    imports = [
        ./hardware-configuration.nix
        ./disko.nix
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
            # alloy.enable = true;
            qemuGuest.enable = true;
            # TBC
            # podman.enable = true;
        };
    };

    networking.hostName = config.modules.system.hostname;

    networking.firewall.allowedTCPPorts = [ 
        8123 # homeassistant
        8080 # zigbee2mqtt
        1883 # mosquitto
        28981 # paperless
        7745 # homebox
        9987 30033 # tsserver
        4856 9837 # sftpgo
    ];

    age.secrets = let

    sftpgo = {
        owner = config.services.sftpgo.user;
        group = config.services.sftpgo.group;
        mode = "440";
    };

    in 

    {

        homebox-envFile.file = ./secrets/homebox-envFile.age;

        mosquitto-iotPassword.file = ./secrets/mosquitto-iotPassword.age;

        paperless-envFile.file = ./secrets/paperless-envFile.age;

        cloudflare-dnsApiToken.file = ./secrets/cloudflare-dnsApiToken.age;

        sftpgo-clientSecret = {
            inherit (sftpgo) owner group mode;
            file = ./secrets/sftpgo-clientSecret.age;
        };
    };

    # services.teamspeak3.enable = true;
    # services.teamspeak3 = {
    #     openFirewall = true;
    #     openFirewallServerQuery = true;
    #     dataDir = "/storage/ts";
    # };

    # services.apcupsd.enable = true;
    # services.apcupsd.configText = ''
    #     UPSCABLE usb
    #     UPSTYPE usb
    #     DEVICE
    #     LOCKFILE /var/lock
    #     UPSCLASS standalone
    #     UPSMODE disable
    # '';

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
            HBOX_OPTIONS_TRUST_PROXY = "true";

            # Directories
            HBOX_STORAGE_CONN_STRING = "file:///storage/homebox";
            HBOX_STORAGE_PREFIX_PATH = "data";
            HOME = "/storage/homebox";
            TMPDIR = "/storage/homebox/tmp";

            # OIDC
            HBOX_OIDC_ENABLED = "true";
            HBOX_OIDC_ISSUER_URL = "https://authelia.${config.modules.server.domain}";
            HBOX_OIDC_CLIENT_ID = "homebox";
            HBOX_OIDC_SCOPE = "openid profile email groups";
            # HBOX_OPTIONS_ALLOW_REGISTRATION = "true";
        };
    };

    # SFTPGo: Fileserver with Virtual Folders and RBAC
    users.users.${config.modules.system.username}.extraGroups = [ "media" ];
    users.groups.media = {};
    services.sftpgo.enable = true;
    services.sftpgo = {
        ## No actual data but holds sftpgo.db
            # dataDir = "/var/lib/sftpgo";
        # Needed when dataDir != <your-wanted-dir>
        extraReadWriteDirs = [ "/storage/media" ];
        # Allow other services to read files
        group = "media";
        settings = {
            ## Sets dirs to 750 and files to 640
            common.umask = "027";

            httpd.bindings = [
                {
                    address = "0.0.0.0";
                    port = 4856;

                    oidc = {
                        client_id = "sftpgo";
                        client_secret_file = "${config.age.secrets.sftpgo-clientSecret.path}";
                        config_url = "https://authelia.${config.modules.server.domain}";
                        # Url to redirect to. != Redirect Url for OIDC which is https://sftpgo.example.com/web/oidc/redirect
                        redirect_base_url = "https://sftpgo.thematt.net";
                        scopes = [ "openid" "profile" "email" ];
                        username_field = "preferred_username";
                        implicit_roles = true;
                    };

                    security = {
                        enabled = true;
                        allowed_hosts = [ "sftpgo.${config.modules.server.domain}" ];
                    };

                    cors = {
                        enabled = true;
                        allowed_origins = [ "sftpgo.${config.modules.server.domain}" ];
                    };
                }
            ];

            webdavd.bindings = [ { address = "0.0.0.0"; port = 9837; } ];
        };
    };

    # Paperless: A Document server with plenty of features (ocr, file conversion, editing, etc.)
    services.paperless.enable = true;
    services.paperless = {
        address = "0.0.0.0";
        port = 28981;
        dataDir = "/storage/paperless";
        configureTika = true;
        ## Also holds SSO
        environmentFile = config.age.secrets.paperless-envFile.path;

        settings = {
            PAPERLESS_URL = "https://paperless.${config.modules.server.domain}";
            PAPERLESS_OCR_LANGUAGE = "eng+deu";
            PAPERLESS_TIME_ZONE = "Europe/Berlin";
            PAPERLESS_TRUSTED_PROXIES = "10.10.12.0/24";
            PAPERLESS_USE_X_FORWARDED_HOST = true;
            PAPERLESS_USE_X_FORWARDED_PORT = true;

            # SSO
            PAPERLESS_LOGOUT_REDIRECT_URL = "https://homepage.${config.modules.server.domain}";
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
