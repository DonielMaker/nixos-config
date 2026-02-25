{ config, inputs, lib, ... }: 

let
    cfg = config.modules.hm;
in with lib;

{
    options.modules.hm = {
        enable = mkEnableOption "Enable Home-manager";

        home = mkOption {
            type = types.path;
            description = "Path to the home.nix";
        };
    };

    imports = [ inputs.home-manager.nixosModules.home-manager];

    config = mkIf cfg.enable {
        
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs;};
            users.${config.modules.system.username} = {
                imports = [ cfg.home ] ++ lib.filesystem.listFilesRecursive "${inputs.self}/modules/hm";

                config.modules.hm.username = config.modules.system.username;
            };
        };
    };
}
