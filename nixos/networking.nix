{lib, hostname, ...}:

{
    networking.networkmanager.enable = true;
    networking.hostName = hostname;
    networking.nameservers = lib.mkDefault [ "10.10.12.10" "1.1.1.1" ];
}
