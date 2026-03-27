{config, ...}:

let
    domain = config.modules.server.domain;
in

{
    users.groups.certs.members = [ "prosody" "nginx" ];
    security.acme = {
        acceptTerms = true;
        defaults.email = "acme@thematt.net";
        defaults.server = "https://acme-v02.api.letsencrypt.org/directory";
        # defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";

        certs."xmpp.${domain}" = {
            group = "certs";

            domain = "xmpp.${domain}";
            extraDomainNames = [ "*.xmpp.${domain}" ];
            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            dnsPropagationCheck = true;
            environmentFile = config.age.secrets.cloudflare-dnsApiToken.path;
        };
    };


    # services.jitsi-meet.enable = true;
    # services.jitsi-videobridge.openFirewall = true;
    # services.jitsi-meet = {
    #     hostName = "xmpp.${domain}";
    #     jibri.enable = true;
    #     jicofo.enable = true;
    #     excalidraw.enable = true;
    #     prosody.enable = false;
    #     nginx.enable = false;
    # };

    # services.prosody.enable = true;
    services.prosody = {
        admins = [ "donielmaker@xmpp.${domain}"];

        ssl = {
            cert = "/var/lib/acme/xmpp.${domain}/fullchain.pem";
            key = "/var/lib/acme/xmpp.${domain}/key.pem";
        };

        httpFileShare = {
            domain = "upload.xmpp.${domain}";
            uploadFileSizeLimit = 100 * 1024 * 1024; # 100MB
        };

        muc = [
        {
            domain = "conference.xmpp.${domain}";
            name = "Chat Rooms";
            restrictRoomCreation = false;
        }
        ];

        virtualHosts."xmpp.${domain}" = {
            enabled = true;
            domain = "xmpp.${domain}";
            ssl = {
                cert = "/var/lib/acme/xmpp.${domain}/fullchain.pem";
                key = "/var/lib/acme/xmpp.${domain}/key.pem";
            };
        };

        # virtualHosts."auth.xmpp.${domain}" = {
        #     enabled = true;
        #     domain = "auth.xmpp.${domain}";
        #     extraConfig = ''
        #         authentication = "internal_hashed"
        #         '';
        #     ssl = {
        #         cert = "/var/lib/acme/xmpp.${domain}/fullchain.pem";
        #         key = "/var/lib/acme/xmpp.${domain}/key.pem";
        #     };
        # };
        #
        # virtualHosts."recorder.xmpp.${domain}" = {
        #     enabled = true;
        #     domain = "recorder.xmpp.${domain}";
        #     extraConfig = ''
        #         authentication = "internal_plain"
        #         c2s_require_encryption = false
        #     '';
        # };
        #
        # virtualHosts."guest.xmpp.${domain}" = {
        #     enabled = true;
        #     domain = "guest.xmpp.${domain}";
        #     extraConfig = ''
        #         authentication = "anonymous"
        #         c2s_require_encryption = false
        #     '';
        # };

        modules = {
            roster = true;
            saslauth = true;
            tls = true;
            dialback = true;
            disco = true;
            carbons = true;
            pep = true;
            mam = true;
            ping = true;
            admin_adhoc = true;
            http_files = true;
        };

        allowRegistration = false;
    };
}
