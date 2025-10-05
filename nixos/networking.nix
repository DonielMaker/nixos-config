{hostname, ...}:

{
    networking.networkmanager.enable = true;
    networking.hostName = hostname;
    # networking.networkmanager.dns = "systemd-resolved";
    # services.resolved.enable = true;
}
