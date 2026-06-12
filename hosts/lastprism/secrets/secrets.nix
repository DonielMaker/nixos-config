let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ2TBsihWMj9xnxsmpBgrZggu8sFKxkzZHmMAhoJxy7g donielmaker@lastprism";
    users = [donielmaker-zenith donielmaker-lastprism];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7nSfLbkp8s9WxMRldwu3mV8K28JGnXOLvUndjwQ4OV";
    systems = [zenith lastprism];
in

{

    # Paperless
    "paperless-envFile.age".publicKeys = users ++ systems;

    # Homebox
    "homebox-envFile.age".publicKeys = users ++ systems;

    # Acme
    # "cloudflare-dnsApiToken.age".publicKeys = users ++ systems;

    # SFTPGo OIDC Client Secret
    "sftpgo-clientSecret.age".publicKeys = users ++ systems;
}
