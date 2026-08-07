let
    server_path = "hosts";

    donielmaker = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTBWBfCU8uM+G5p6vl0dwc0Q7XA6TypesGZWzbbpiwx donielmaker@galaxia"
    ];

    lastprism = {
        path = "${server_path}/lastprism/secrets";
        key = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7nSfLbkp8s9WxMRldwu3mV8K28JGnXOLvUndjwQ4OV" ];
    };

    miasma = {
        path = "${server_path}/miasma/secrets";
        key = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZZSSXJMhkykxUFP6A+zSnvBIsSGkBdRLHdcKshzIH6"];
    };

in

{
    # === Lastprism ===

    # Paperless
    "${lastprism.path}/paperless-envFile.age".publicKeys = donielmaker ++ lastprism.key;

    # Homebox
    "${lastprism.path}/homebox-envFile.age".publicKeys = donielmaker ++ lastprism.key;

    # SFTPGo
    "${lastprism.path}/sftpgo-clientSecret.age".publicKeys = donielmaker ++ lastprism.key;

    # Beszel Secrets
    "${lastprism.path}/beszel/key.age".publicKeys = donielmaker ++ lastprism.key;
    "${lastprism.path}/beszel/token.age".publicKeys = donielmaker ++ lastprism.key;

    # === Miasma ===

    # Authelia
    "${miasma.path}/authelia/jwtSecret.age".publicKeys = donielmaker ++ miasma.key;
    "${miasma.path}/authelia/storageEncryptionKey.age".publicKeys = donielmaker ++ miasma.key;
    "${miasma.path}/authelia/sessionSecret.age".publicKeys = donielmaker ++ miasma.key;
    "${miasma.path}/authelia/oidcIssuerPrivateKey.age".publicKeys = donielmaker ++ miasma.key;

    # Cloudflare
    "${miasma.path}/cloudflare-dnsApiToken.age".publicKeys = donielmaker ++ miasma.key;

    # Vaultwarden
    "${miasma.path}/vaultwarden-env.age".publicKeys = donielmaker ++ miasma.key;

    # Beszel Secrets
    "${miasma.path}/beszel/key.age".publicKeys = donielmaker ++ miasma.key;
    "${miasma.path}/beszel/token.age".publicKeys = donielmaker ++ miasma.key;
}
