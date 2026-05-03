{ config, inputs, lib, ... }: 

let
    inherit (lib) mkEnableOption mkOption types mkIf;
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
                    system = {
                        username = config.modules.system.username;
                        mail = config.modules.system.username;
                        keyboard.layout = config.modules.system.keyboard.layout;
                    };

                    programs.librewolf = config.modules.programs.librewolf;

                    hypr = config.modules.desktop.hyprland;
                };
            };

            users.${config.modules.system.username}.imports = [ cfg.home ];
        };
    };
}
