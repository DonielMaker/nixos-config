{inputs, pkgs, pkgs-stable}:

settingsPath:

let
    conf = import "${settingsPath}/configuration.nix";
    settings = import "${settingsPath}/settings.nix"; 
    arch = pkgs.stdenv.hostPlatform.system;

    specialArgs = {inherit inputs pkgs-stable arch;} // settings;
in

inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules = [ conf { nixpkgs.pkgs = pkgs; } ];
}

