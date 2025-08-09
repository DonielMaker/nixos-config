let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJKPcDx4OaeQQddjfmLhciy4nV2HBKMSZREA8YyCGCCP donielmaker@lastprism";
    users = [donielmaker-zenith donielmaker-lastprism];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP6qX8oh3vPvjm3EL9XI/zmY5FgyAI7SVkl15+t0tvM4";
    systems = [zenith lastprism];
in
{
    "jwtSecret.age".publicKeys = [donielmaker-zenith donielmaker-lastprism zenith lastprism];
    "storageEncryptionKey.age".publicKeys = [donielmaker-zenith donielmaker-lastprism zenith lastprism];
    "sessionSecret.age".publicKeys = [donielmaker-zenith donielmaker-lastprism zenith lastprism];
    "autheliaLldapPassword.age".publicKeys = [donielmaker-zenith donielmaker-lastprism zenith lastprism];
    "cloudflareDnsApiToken.age".publicKeys = [donielmaker-zenith donielmaker-lastprism zenith lastprism];
}
