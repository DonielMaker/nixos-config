{inputs, system, pkgs, pkgs-stable}:

settingsPath: 

let
    home = import "${settingsPath}/home.nix";
    settings = import "${settingsPath}/settings.nix"; 
    extraSpecialArgs = {inherit system pkgs pkgs-stable inputs;} // settings;
in

inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs extraSpecialArgs;
    modules = [ home ];
}
