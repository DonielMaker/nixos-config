let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    donielmaker-galaxia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTBWBfCU8uM+G5p6vl0dwc0Q7XA6TypesGZWzbbpiwx donielmaker@galaxia";
    donielmaker-miasma = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKg2vtnvXatSMA1GXaP4J2JXz4Ss4OHlKAqEHiXywLjQ donielmaker@miasma";
    users = [ donielmaker-zenith donielmaker-miasma donielmaker-galaxia ];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    galaxia = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKkebkctZ2f6Df+ujM9XOeDSGteb5QNT8TowV4aEjINK";
    miasma = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZZSSXJMhkykxUFP6A+zSnvBIsSGkBdRLHdcKshzIH6";
    systems = [ zenith miasma galaxia ];
in

{
    "authelia/jwtSecret.age".publicKeys = users ++ systems;
    "authelia/storageEncryptionKey.age".publicKeys = users ++ systems;
    "authelia/sessionSecret.age".publicKeys = users ++ systems;
    "authelia/lldapPassword.age".publicKeys = users ++ systems;
    "authelia/jwksKey.age".publicKeys = users ++ systems;

    "authentik/secret.env.age".publicKeys = users ++ systems;
    "authentik/proxy.env.age".publicKeys = users ++ systems;

    "grafana/clientSecret.age".publicKeys = users ++ systems;

    "cloudflare/dnsApiToken.age".publicKeys = users ++ systems;

    "vaultwarden-env.age".publicKeys = users ++ systems;
}
