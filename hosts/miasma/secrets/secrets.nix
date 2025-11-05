let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-galaxia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTBWBfCU8uM+G5p6vl0dwc0Q7XA6TypesGZWzbbpiwx donielmaker@galaxia";
    donielmaker-miasma = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFF6799VjHuSA14fxZQ9zI+6FC2yoZTJFW0Cq7ZW3ed5 donielmaker@miasma";
    users = [ donielmaker-zenith donielmaker-miasma donielmaker-galaxia ];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    galaxia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKkebkctZ2f6Df+ujM9XOeDSGteb5QNT8TowV4aEjINK";
    miasma = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBir991rACOjmulpmKmn7a27R6e8R+OgXFLMRN5aSUeg";
    systems = [ zenith miasma galaxia ];
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
