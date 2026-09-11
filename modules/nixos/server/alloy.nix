{ config, lib, ... }: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.server.alloy;
in

{
    options.modules.server.alloy.enable = mkEnableOption "Enable Grafana Alloy";

    config = mkIf cfg.enable {

        networking.firewall.allowedTCPPorts = [ 12345 ];

        services.alloy.enable = true;
        services.alloy.extraFlags = [ "--server.http.listen-addr=0.0.0.0:12345" "--disable-reporting" ];

        environment.etc."alloy/config.alloy".text = ''
            // Scrape Unix Metrics
            prometheus.exporter.unix "metrics" {
                enable_collectors = [ "systemd", "meminfo" ]
                disable_collectors = [ "ipvs", "btrfs", "infiniband", "nfs", "nfsd", "selinux", "xfs", "zfs" ]

                systemd {
                    enable_restarts = true
                    start_time      = true
                    task_metrics    = true
                    unit_include    = ".+\\.service$"
                }
            }

            // Relabel Unix Metrics
            discovery.relabel "metrics" {
                targets = prometheus.exporter.unix.metrics.targets

                // Replace instance name with server hostname
                rule {
                    target_label = "instance"
                    replacement  = constants.hostname
                }

                // Replace job name with "hostname-metrics"
                rule {
                    target_label = "job"
                    replacement = string.format("%s-metrics", constants.hostname)
                }
            }

            // Scrape every 15s
            prometheus.scrape "metrics" {
                scrape_interval = "15s"
                targets = discovery.relabel.metrics.output
                forward_to = [prometheus.remote_write.metrics.receiver]
            }

            // Send to Prometheus
            prometheus.remote_write "metrics" {
                endpoint {
                    url = "http://miasma.${config.networking.domain}:9090/api/v1/write"
                }
            }

            discovery.relabel "journal_logs" {
                targets = []

                rule {
                    source_labels = ["__journal__systemd_unit"]
                    target_label  = "unit"
                }

                rule {
                    source_labels = ["__journal__boot_id"]
                    target_label  = "boot_id"
                }

                rule {
                    source_labels = ["__journal__transport"]
                    target_label  = "transport"
                }

                rule {
                    source_labels = ["__journal_priority_keyword"]
                    target_label  = "level"
                }
            }

            // Journald logs
            loki.source.journal "journal_logs" {
                max_age       = "24h0m0s"
                relabel_rules = discovery.relabel.journal_logs.rules
                forward_to    = [loki.write.logs.receiver]
            }

            // Filesystem logs
            local.file_match "fs_logs" {
                path_targets = [{
                    __address__ = "localhost",
                    __path__    = "/var/log/{syslog,messages,technitium/dns/*.log,*.log}",
                    instance    = constants.hostname,
                    job         = string.format("%s-logs", constants.hostname),
                }]
            }

            loki.source.file "fs_logs" {
                targets    = local.file_match.fs_logs.targets
                forward_to = [loki.write.logs.receiver]
            }

            // Send to loki
            loki.write "logs" {
                endpoint {
                    url = "http://miasma.${config.networking.domain}:3100/loki/api/v1/push"
                }
            }
        '';
    };
}
