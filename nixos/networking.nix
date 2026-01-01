{lib, hostname, domain, ...}:

{
    networking.networkmanager.enable = true;
    networking.hostName = hostname;
    networking.domain = domain;
    networking.nameservers = lib.mkDefault [ "10.10.12.10" "1.1.1.1" ];
}
