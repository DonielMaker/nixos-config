{inputs, system, pkgs, pkgs-stable}:

settingsPath:

let
    conf = import "${settingsPath}/configuration.nix";
    settings = import "${settingsPath}/settings.nix"; 

    specialArgs = {inherit system pkgs pkgs-stable inputs;} // settings;
in

inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules = [ conf ];
}

