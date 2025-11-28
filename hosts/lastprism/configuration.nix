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

        alloy
    ];

    # copyparty, radicale, homeassistant, zigbee2mqtt, mosquitto, shiori, trilium
    networking.firewall.allowedTCPPorts = [ 3923 5232 8123 8080 1883 7571 8965 ];

    powerManagement.powertop.enable = true;

    users.users.donielmaker.extraGroups = [ "media" ];

    users.groups.media = {};

    systemd.tmpfiles.rules = [
        "d /storage/media 0770 copyparty media -"
        "d /storage/media/pictures 0770 copyparty media -"
        "d /storage/media/videos 0770 copyparty media -"
        "d /storage/media/music 0770 navidrome media -"
        "d /storage/media/documents 0770 copyparty media -"
    ];

    age.secrets = let

        copyparty = {
            mode = "440";
            owner = config.services.copyparty.user;
            group = config.services.copyparty.group;
        };
    in

    {
        copyparty-donielmaker-password = {
            inherit (copyparty) mode owner group;
            file = ./secrets/copyparty/copyparty-donielmaker-password.age;
        };
    };

    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

    networking.nameservers = [ "10.10.12.10" ];

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

    services.trilium-server.enable = true;
    services.trilium-server = {
        dataDir = "/storage/trilium";
        port = 8965;
        host = "0.0.0.0";
    };

    systemd.services.trilium-server.environment = {
        TRILIUM_NETWORK_TRUSTEDREVERSEPROXY = "10.10.12.10";
        TRILIUM_NETWORK_CORS_ALLOW_ORIGIN = "https://trilium.thematt.net";
    };

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

    nix.settings.trusted-users = [ "donielmaker" ];

    environment.systemPackages = with pkgs; [
        inputs.ragenix.packages.${system}.default

        vim
        git
    ];

    system.stateVersion = "25.11"; # Just don't
}
