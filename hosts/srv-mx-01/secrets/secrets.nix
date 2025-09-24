let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    solut-srv-mx-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMrlNi2ZBhJmeNEiVLg6fqIywfg3nZnRZ99xqVYWZbZN donielmaker@lastprism-max";
    anton-spc-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwnQCbrIxOgzRpoEYyb/SaoDhM5i93wWJ8biH/f8ygT deuyanon@SPC-01";
    users = [donielmaker-zenith solut-srv-mx-01 anton-spc-01];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    srv-mx-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBmS6gxfWFbVP5qZPxAgcGjKbZHYqQcfBODSiGjoY3M0";
    spc-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFSM5bfdGl9OUuKchV23PVogIf0ZGvH3XeOwtzuuDfep";
    systems = [zenith srv-mx-01 spc-01];

     
in
{
    "ipv64DnsApiToken.age".publicKeys = users ++ systems;
}
