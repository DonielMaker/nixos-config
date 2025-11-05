let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMWLLqlBUTjozxsybGqwNu0dmqvANB103SZQnlX+tZ7y donielmaker@lastprism";
    users = [donielmaker-zenith donielmaker-lastprism];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFiN6GBFPWtkNhWeSLRTN8yLIXs6BkNQQf1L7nF4Zv3";
    systems = [zenith lastprism];
in
{
    # Copyparty Passwords
    "copyparty/copyparty-donielmaker-password.age".publicKeys = users ++ systems;
}
