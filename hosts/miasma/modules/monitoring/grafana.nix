{ config, lib, ...}:

let
    inherit (lib) mkIf;
    domain = config.networking.domain;
in

{
    config = mkIf config.modules.server.monitoring.enable {

        networking.firewall.allowedTCPPorts = [ 6778 ];

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
                # role_attribute_path = "contains(groups[*], 'admins') && 'Admin' || 'Viewer'"; # Needs further testing
                role_attribute_path = "\"'GrafanaAdmin'\"";
            };
        };
    };
}
