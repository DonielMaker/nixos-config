{hostname, ...}:

{
    networking.networkmanager.enable = true;
    networking.networkmanager.dns = "none";
    networking.search = [ "thematt.net" ];
    networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networking.hostName = hostname;
    networking.useDHCP = false;
    networking.dhcpcd.enable = false;
}
