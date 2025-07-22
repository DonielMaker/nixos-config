let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-galaxia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGCA4si0+PqWQn/PRtfOeuCIK3ISIvMKfvQhciwPQvh donielmaker@galaxia";
    users = [donielmaker-zenith donielmaker-galaxia];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    galaxia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMh8lotSDAT4cQz7O6C0DyEtSxY/lqCbTb6IZC5vuAz1";
    systems = [zenith galaxia];
in
{
    "wireguard-priKey.age".publicKeys = [donielmaker-zenith donielmaker-galaxia zenith galaxia];
    "wireguard-shrKey.age".publicKeys = [donielmaker-zenith donielmaker-galaxia zenith galaxia];
}
