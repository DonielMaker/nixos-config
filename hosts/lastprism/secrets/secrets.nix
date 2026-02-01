let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIF6bUoSt3TnuVLcPtdmbEnLl/8uCn/hspLlJqg289Zl donielmaker@lastprism";
    users = [donielmaker-zenith donielmaker-lastprism];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    lastprism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEvXk41EZG7NmAeFp8SAV/By7no2a7HpWmyP8ex0D4He";
    systems = [zenith lastprism];
in

{
    # Copyparty
    "copyparty/copyparty-donielmaker-password.age".publicKeys = users ++ systems;

    # Outline
    "outline/utilsSecret.age".publicKeys = users ++ systems;
    "outline/secretKey.age".publicKeys = users ++ systems;
    "outline/clientSecret.age".publicKeys = users ++ systems;

    # Radicale
    "radicale/password.age".publicKeys = users ++ systems;
}
