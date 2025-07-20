let
    user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";

    system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
in
{
    "secret1.age".publicKeys = [ user1 system1 ];
    "secret2.age".publicKeys = [ user1 system1 ];

    "wireguard-shrKey.age".publicKeys = [ user1 system1 ];
    "wireguard-priKey.age".publicKeys = [ user1 system1 ];
}
