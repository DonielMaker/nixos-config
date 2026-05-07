{ config, lib, inputs, ...}: 

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.system;
in

{
    options.modules.terminal.git.enable = mkEnableOption "Enable git";

    imports = with inputs; [
        disko.nixosModules.disko
        ragenix.nixosModules.default
    ];

    config.home-manager.users.${config.modules.system.username} = mkIf cfg.enable ({ modules, ... }: {

        programs.git.enable = true;
        programs.git.settings = {
            user.name = modules.system.username;
            user.email = modules.system.mail;
        };
    });
}
