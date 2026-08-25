{ config, ...}:

let
    domain = config.networking.domain;
in

{

    services.grafana.enable = true;
    services.grafana.settings = {
        server = {
            http_addr = "0.0.0.0";
            http_port = 6778;
            root_url = "https://grafana.${domain}";
        };

        security.secret_key = "$__file{${config.age.secrets.grafana-secretKey.path}}";

        "auth.generic_oauth" = {
            enabled = true;
            name = "Authelia";

            client_id = "grafana";
            client_secret = "$__file{${config.age.secrets.grafana-clientSecret.path}}";
            use_pkce = true;
            scopes = "openid profile email groups";

            auth_url = "https://authelia.${domain}/api/oidc/authorization";
            token_url = "https://authelia.${domain}/api/oidc/token";
            api_url = "https://authelia.${domain}/api/oidc/userinfo";

            name_attribute_path = "display_name";
            login_attribute_path = "preferred_username";
            groups_attribute_path = "groups";
            # role_attribute_path = "contains(groups[*], 'admins') && 'Admin' || 'Viewer'";
            role_attribute_path = "\"'GrafanaAdmin'\"";

            signout_redirect_url = "https://homepage.${domain}";
        };
    };

    services.prometheus.enable = true;
    services.prometheus = {
        webExternalUrl = "https://prometheus.${domain}";
        port = 9090;
        globalConfig.scrape_interval = "15s";
        scrapeConfigs = [
            {
                job_name = "miasma-metrics";
                static_configs = [{
                    targets = [ "miasma.thematt.net:9100"];
                }];
            } 
            {
                job_name = "miasma-systemd";
                static_configs = [{
                    targets = [ "miasma.thematt.net:9558"];
                }];
            } 
            # {
            #     job_name = "lastprism-metrics";
            #     static_configs = [{
            #         targets = [ "lastprism.thematt.net:9100"];
            #     }];
            # } 
        ];
    };

    services.prometheus.exporters.node = {
        enable = true;
        openFirewall = true;
        enabledCollectors = [ "systemd" "meminfo" ];
        disabledCollectors = [ "ipvs" "bcache" "bcachefs" "infiniband" "xfs" ];
    };

    services.prometheus.exporters.systemd = {
        enable = true;
        openFirewall = true;
    };
}
