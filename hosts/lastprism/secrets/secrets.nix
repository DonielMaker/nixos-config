let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIF6bUoSt3TnuVLcPtdmbEnLl/8uCn/hspLlJqg289Zl donielmaker@lastprism";
    users = [donielmaker-zenith donielmaker-lastprism];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEvXk41EZG7NmAeFp8SAV/By7no2a7HpWmyP8ex0D4He";
    systems = [zenith lastprism];
in

{
    # Mosquitto
    "mosquitto-iotPassword.age".publicKeys = users ++ systems;

    # Paperless
    "paperless-envFile.age".publicKeys = users ++ systems;

    # Homebox
    "homebox-envFile.age".publicKeys = users ++ systems;

    # Acme
    "cloudflare-dnsApiToken.age".publicKeys = users ++ systems;

    # SFTPGo OIDC Client Secret
    "sftpgo-clientSecret.age".publicKeys = users ++ systems;
}
