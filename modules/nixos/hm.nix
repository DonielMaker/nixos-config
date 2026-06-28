{ config, inputs, lib, ... }: 

let
    inherit (lib) mkEnableOption mkOption mkIf types;
    cfg = config.modules.hm;
in

{
    options.modules.hm = {
        enable = mkEnableOption "Enable Home-manager";

        home = mkOption {
            type = types.path;
            description = "Path to the home.nix";
        };
    };

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    config = mkIf cfg.enable {
        
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };

            users.${config.modules.system.username}.imports = [ cfg.home ] ++ lib.filesystem.listFilesRecursive "${inputs.self}/modules/hm";
        };
    };
}
