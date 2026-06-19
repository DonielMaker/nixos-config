{ config, ...}:

{

    # services.grafana.enable = true;
    # services.grafana.settings = {
    #     server = {
    #         http_addr = "0.0.0.0";
    #         http_port = 6778;
    #         root_url = "https://grafana.${config.modules.server.domain}";
    #     };
    #
    #     security.secret_key = "$__file{${config.age.secrets.grafana-secretKey.path}}";
    #
    #     "auth.generic_oauth" = {
    #         enabled = true;
    #         name = "Authentik";
    #         icon = "signin";
    #         client_id = "grafana";
    #         client_secret = "$__file{${config.age.secrets.grafanaClientSecret.path}}";
    #         scopes = "openid profile email groups";
    #         empty_scopes = false;
    #         auth_url = "https://authentik.${config.modules.server.domain}/application/o/authorize/";
    #         token_url = "https://authentik.${config.modules.server.domain}/application/o/token/";
    #         api_url = "https://authentik.${config.modules.server.domain}/application/o/userinfo/";
    #         login_attribute_path = "preferred_username";
    #         groups_attribute_path = "groups";
    #         name_attribute_path = "display_name";
    #         use_pkce = true;
    #         signout_redirect_url = "https://homepage.${config.modules.server.domain}";
    #         skip_org_role_sync = true;
    #     };
    # };

    # services.prometheus.enable = true;
    # services.prometheus.extraFlags = [ "--web.enable-remote-write-receiver" ];
    # services.prometheus = {
    #     webExternalUrl = "https://prometheus.${config.modules.server.domain}";
    #     port = 9090;
    #     globalConfig.scrape_interval = "15s";
    #     scrapeConfigs = [
    #         # {
    #         #     job_name = "miasma-metrics";
    #         #     static_configs = [{
    #         #         targets = [ "miasma.thematt.net:9100"];
    #         #     }];
    #         # } 
    #         # {
    #         #     job_name = "lastprism-metrics";
    #         #     static_configs = [{
    #         #         targets = [ "lastprism.thematt.net:9100"];
    #         #     }];
    #         # } 
    #     ];
    # };

    # services.prometheus.exporters.node = {
    #     enable = true;
    #     openFirewall = true;
    #     enabledCollectors = [ "systemd" "meminfo" ];
    #     disabledCollectors = [ "ipvs" "btrfs" "infiniband" "xfs" "zfs" ];
    # };
}
