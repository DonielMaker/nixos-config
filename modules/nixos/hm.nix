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
            extraSpecialArgs = {
                inherit inputs; 
                modules = {
                    # For some reason evaluation changes when these are placed in their specific module (Maybe due to them no longer being in scope).
                    system = {
                        username = config.modules.system.username;
                        mail = config.modules.system.username;
                        keyboard.layout = config.modules.system.keyboard.layout;
                    };

                    hypr = config.modules.desktop.hyprland;
                };
            };

            users.${config.modules.system.username}.imports = [ cfg.home ] ++ lib.filesystem.listFilesRecursive "${inputs.self}/modules/hm";
        };
    };
}
