{inputs, system, pkgs, pkgs-stable, myLib}:

settingsPath: 

let
    home = import "${settingsPath}/home.nix";
    settings = import "${settingsPath}/settings.nix"; 
    extraSpecialArgs = {inherit system pkgs-stable inputs myLib;} // settings;
in

inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs extraSpecialArgs;
    modules = [ home ];
}
