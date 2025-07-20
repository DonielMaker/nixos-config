let
    donielmaker = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
in
{
    "secret1.age".publicKeys = [ donielmaker zenith ];
    "secret2.age".publicKeys = [ donielmaker zenith ];

    "wireguard-shrKey.age".publicKeys = [ donielmaker zenith ];
    "wireguard-priKey.age".publicKeys = [ donielmaker zenith ];
}
