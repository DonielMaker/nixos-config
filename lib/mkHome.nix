{inputs, pkgs, pkgs-stable}:

settingsPath: 

let
    home = import "${settingsPath}/home.nix";
    settings = import "${settingsPath}/settings.nix" {inherit pkgs;}; 
    arch = pkgs.stdenv.hostPlatform.system;

    extraSpecialArgs = {inherit inputs pkgs-stable arch;} // settings;
in

inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs extraSpecialArgs;
    modules = [ home ];
}
