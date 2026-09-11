{inputs, pkgs, pkgs-stable, ...}:

let 
    lib = inputs.nixpkgs.lib;
in

{

    # Creates the Nixos Configurations
    mkNixos = settingsPath:

    let
        conf = import "${settingsPath}/configuration.nix";
        sLib = import ./. {inherit inputs pkgs pkgs-stable;};
        specialArgs = {inherit inputs pkgs-stable sLib;};
    in

    inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [ conf { nixpkgs.pkgs = pkgs; } ] ++ lib.filesystem.listFilesRecursive "${inputs.self}/modules/nixos";
    };

    # List of all .nix files under <path>
    nixFiles = path: lib.filter (file: lib.hasSuffix ".nix" file) (lib.filesystem.listFilesRecursive path);
}
