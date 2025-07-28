{hostname, ...}:

{
    networking.networkmanager.enable = true;
    networking.hostName = hostname;
    networking.nameservers = [
        "10.10.12.2"
        "1.1.1.1"
    ];
}
