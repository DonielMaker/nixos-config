{inputs, pkgs, pkgs-stable, ...}:

let 
    lib = inputs.nixpkgs.lib;
in


rec {

    # Creates the inputs.self.outputs.nixosConfiguration
    mkNixos = settingsPath:

    let
        conf = import "${settingsPath}/configuration.nix";
        # Might get replaced with an option
        settings = import "${settingsPath}/settings.nix" {inherit pkgs;}; 
        arch = pkgs.stdenv.hostPlatform.system;

        # Might be replaced by options
        specialArgs = {inherit inputs pkgs-stable arch;} // settings;
    in

    inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [ conf { nixpkgs.pkgs = pkgs; } ];
    };

    # Creates the inputs.self.outputs.homeManagerConfiguration
    mkHome = settingsPath: 

    let
        home = import "${settingsPath}/home.nix";
        # Might get replaced with an option
        settings = import "${settingsPath}/settings.nix" {inherit pkgs;}; 
        arch = pkgs.stdenv.hostPlatform.system;

        # Might be replaced by options
        extraSpecialArgs = {inherit inputs pkgs-stable arch;} // settings;
    in

    inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [ home ];
    };

    # Turns a directory like such:
    #
    # test
    # ├── dir1
    # │   ├── file2-1.nix
    # │   ├── file2-2.nix
    # │   └── file2-3.nix
    # ├── file1-1.nix
    # ├── file1-2.nix
    # ├── file1-3.nix
    # └── file1-4.nix
    #
    # Into an attrSet like this:
    # 
    # {
    #     file1-1 = /test/file1-1.nix; 
    #     file1-2 = /test/file1-2.nix; 
    #     file1-3 = /test/file1-3.nix; 
    #     file1-4 = /test/file1-4.nix; 
    #     dir1.file2-1 = /test/dir1/dir1.file2-1.nix;
    #     dir1.file2-2 = /test/dir1/dir1.file2-2.nix;
    #     dir1.file2-3 = /test/dir1/dir1.file2-3.nix;
    # }
    mkModules = suffix: dir: _fixNames suffix dir;

    # This build the recursive file tree as such:
    # {
    #   dir1 = {
    #     dir2 = { "file2-1.nix" = "/home/<name>/.config/nix/test/dir1/dir2/file2-1.nix"; };
    #     "file1-1.nix" = "/home/<name>/.config/nix/test/dir1/file1-1.nix";
    #     "file1-2.nix" = "/home/<name>/.config/nix/test/dir1/file1-2.nix";
    #   };
    #   "file1.nix" = "/home/<name>/.config/nix/test/file1.nix";
    #   "file2.nix" = "/home/<name>/.config/nix/test/file2.nix";
    # }
    _buildFileTree = dir: lib.mapAttrs 
        (name: value:
            if value == "directory" 
            then (_buildFileTree "${toString dir}/${name}") 
            else "${toString dir}/${name}"
        ) (builtins.readDir dir);

    # This fixes up all the .nix suffixes from _buildFileTree
    _fixNames = suffix: dir: lib.attrsets.concatMapAttrs 
        (name: value: 
            {
                # attrName
                ${lib.removeSuffix suffix name} = 
                    if builtins.isAttrs value 
                    then (_fixNames ".nix" "${toString dir}/${name}") 
                    else value;
            }
        ) (_buildFileTree dir);
}
