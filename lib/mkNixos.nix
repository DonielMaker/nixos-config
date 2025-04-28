{inputs, system, pkgs, pkgs-stable}:

settingsPath: 

let
    conf = import "${settingsPath}/configuration.nix";
    home = import "${settingsPath}/home.nix";
    settings = import "${settingsPath}/settings.nix"; 

    specialArgs = {inherit system pkgs pkgs-stable inputs;} // settings;
in

inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules = [
        # Since specialArgs.pkgs is set
        inputs.nixpkgs.nixosModules.readOnlyPkgs
        conf
    ] ++
    [
        inputs.home-manager.nixosModules.home-manager {
            home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.${settings.username}.imports = [home];
            };
        }
    ];  
}
