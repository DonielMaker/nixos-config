let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-galaxia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTBWBfCU8uM+G5p6vl0dwc0Q7XA6TypesGZWzbbpiwx donielmaker@galaxia";
    users = [donielmaker-zenith donielmaker-galaxia];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    galaxia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKkebkctZ2f6Df+ujM9XOeDSGteb5QNT8TowV4aEjINK";
    systems = [zenith galaxia];
in
{
    "wireguard-priKey.age".publicKeys = users ++ systems;
}
