let
    donielmaker-zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith";
    anton-spc-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwnQCbrIxOgzRpoEYyb/SaoDhM5i93wWJ8biH/f8ygT deuyanon@SPC-01";
    solut-srv-mx-01 = "";
    users = [donielmaker-zenith anton-spc-01];

    zenith = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE9OsEE+anE42quYmi3ewEsxA/jiopIzdjdAaXa05t/m";
    spc-01 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFSM5bfdGl9OUuKchV23PVogIf0ZGvH3XeOwtzuuDfep";
    srv-mx-01 = "";
    systems = [zenith spc-01];

     
in
{
    
    "cloudflareDnsApiToken.age".publicKeys = users ++ systems;
}
