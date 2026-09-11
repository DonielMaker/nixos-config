{ config, lib, ...}:

let
    inherit (lib) mkIf;
    domain = config.networking.domain;
in

{
    config = mkIf config.modules.server.monitoring.enable {

        services.prometheus.alertmanager.enable = true;
        services.prometheus.alertmanager = {
            openFirewall = true;
            webExternalUrl = "https://alertmanager.${domain}";
            checkConfig = false;
            configuration = {
                global = {
                    smtp_smarthost = "mail.${domain}:587";
                    smtp_from = "alerts@${domain}";
                    smtp_auth_username = "alerts@${domain}";
                    smtp_auth_password_file = config.age.secrets.alertmanager-smtpPassword.path;
                };

                route = {
                    group_by = ["instance"]; # group by 'instance' label to prevent spam
                    group_wait = "30s";      # delay alerts by 30s to collect grouped events
                    group_interval = "1m";   # notify about updates in the group every minute
                    repeat_interval = "8h";  # repeat alerts all 8h

                    receiver = "mail";
                };

                receivers = [
                    {
                        name = "null";
                    }
                    {
                        name = "mail";
                        email_configs = [
                            { to = "donielmaker@${domain}"; }
                        ];
                    }
                ];
            };
        };
    };
}

