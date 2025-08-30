let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-lastprism-max = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrlNi2ZBhJmeNEiVLg6fqIywfg3nZnRZ99xqVYWZbZN donielmaker@lastprism-max";
    users = [donielmaker-zenith donielmaker-lastprism-max];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    lastprism-max = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBmS6gxfWFbVP5qZPxAgcGjKbZHYqQcfBODSiGjoY3M0";
    systems = [zenith lastprism-max];
in
{
    # "jwtSecret.age".publicKeys = [donielmaker-zenith donielmaker-lastprism zenith lastprism];
    # "storageEncryptionKey.age".publicKeys = [donielmaker-zenith donielmaker-lastprism zenith lastprism];
    # "sessionSecret.age".publicKeys = [donielmaker-zenith donielmaker-lastprism zenith lastprism];
    # "autheliaLldapPassword.age".publicKeys = [donielmaker-zenith donielmaker-lastprism zenith lastprism];
    "ipv64DnsApiToken.age".publicKeys = [donielmaker-zenith donielmaker-lastprism-max zenith lastprism-max];
}
