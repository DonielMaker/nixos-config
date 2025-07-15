{inputs, system, pkgs, pkgs-stable, myLib}:

settingsPath:

let
    conf = import "${settingsPath}/configuration.nix";
    settings = import "${settingsPath}/settings.nix"; 

    specialArgs = {inherit system pkgs-stable inputs myLib;} // settings;
in

inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules = [
        conf 
        {
            nixpkgs.pkgs = pkgs;
        }
    ];
}

