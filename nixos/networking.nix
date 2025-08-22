{hostname, ...}:

{
    networking.networkmanager.enable = true;
    # networking.networkmanager.dns = "systemd-resolved";
    # services.resolved.enable = true;

    networking.search = [
        "thematt.net"
    ];
    networking.hostName = hostname;
}
