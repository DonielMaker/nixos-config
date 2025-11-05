let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-miasma = "";
    users = [ donielmaker-zenith ];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    miasma = "";
    systems = [ zenith ];
in
{
    # Secrets dedicated to authelia
    "authelia/jwtSecret.age".publicKeys = users ++ systems;
    "authelia/storageEncryptionKey.age".publicKeys = users ++ systems;
    "authelia/sessionSecret.age".publicKeys = users ++ systems;
    "authelia/autheliaLldapPassword.age".publicKeys = users ++ systems;
    "authelia/autheliaJwksKey.age".publicKeys = users ++ systems;

    "cloudflareDnsApiToken.age".publicKeys = users ++ systems;
}
