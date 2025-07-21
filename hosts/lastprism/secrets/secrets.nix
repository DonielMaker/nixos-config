let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2FlssgN97CKHkigZ/C6bGLTEkB+IbPZQHK/0ybIBF6";
in
{
    "jwtSecret.age".publicKeys = [donielmaker-zenith zenith lastprism];
    "storageEncryptionKey.age".publicKeys = [donielmaker-zenith zenith lastprism];
    "sessionSecret.age".publicKeys = [donielmaker-zenith zenith lastprism];
    "autheliaLldapPassword.age".publicKeys = [donielmaker-zenith zenith lastprism];
    "cloudflare.age".publicKeys = [donielmaker-zenith zenith lastprism];
}
