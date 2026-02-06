{domain, ...}: 

{
    networking.firewall.allowedTCPPorts = [ 12345 ];

    services.alloy.enable = true;
    services.alloy.extraFlags = [ "--server.http.listen-addr=0.0.0.0:12345" ];
    environment.etc."alloy/config.alloy".text = ''
        prometheus.exporter.unix "metrics" {
            disable_collectors = ["ipvs", "btrfs", "infiniband", "xfs", "zfs"]
            enable_collectors = ["meminfo"]

            filesystem {
                fs_types_exclude     = "^(autofs|binfmt_misc|bpf|cgroup2?|configfs|debugfs|devpts|devtmpfs|tmpfs|fusectl|hugetlbfs|iso9660|mqueue|nsfs|overlay|proc|procfs|pstore|rpc_pipefs|securityfs|selinuxfs|squashfs|sysfs|tracefs)$"
                mount_points_exclude = "^/(dev|proc|run/credentials/.+|sys|var/lib/docker/.+)($|/)"
                mount_timeout        = "5s"
            }

            netclass {
                ignored_devices = "^(veth.*|cali.*|[a-f0-9]{15})$"
            }

            netdev {
                device_exclude = "^(veth.*|cali.*|[a-f0-9]{15})$"
            }
        }

        discovery.relabel "metrics" {
            targets = prometheus.exporter.unix.metrics.targets

            rule {
                target_label = "instance"
                replacement  = constants.hostname
            }

            rule {
                target_label = "job"
                replacement = string.format("%s-metrics", constants.hostname)
            }
        }

        prometheus.scrape "metrics" {
            scrape_interval = "15s"
            targets = discovery.relabel.metrics.output
            forward_to = [prometheus.remote_write.metrics.receiver]
        }

        prometheus.remote_write "metrics" {
            endpoint {
                url = "http://prometheus.${domain}:9090/api/v1/write"
            }
        }
    '';
}
