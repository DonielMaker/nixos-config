let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
in
{
    "jwtSecret.age".publicKeys = [donielmaker-zenith zenith];
    "storageEncryptionKeyFile.age".publicKeys = [donielmaker-zenith zenith];
    "sessionSecret.age".publicKeys = [donielmaker-zenith zenith];
    "autheliaLldapPassword.age".publicKeys = [donielmaker-zenith zenith];
    "cloudflare.age".publicKeys = [donielmaker-zenith zenith];
}
