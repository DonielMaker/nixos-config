{lib, hostname, ...}:

{
    networking.networkmanager.enable = true;
    networking.hostName = hostname;
    networking.networkmanager.dns = "systemd-resolved";
    networking.nameservers = lib.mkDefault [ "10.10.12.10" "10.10.110.10" "1.1.1.1" ];

    services.resolved.enable = true;
    services.resolved.domains = lib.mkDefault [ "thematt.net" "soluttech.uk" ];
}
