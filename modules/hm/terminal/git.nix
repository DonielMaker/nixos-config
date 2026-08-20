{ osConfig, lib, ...}: 

let
    inherit (lib) mkIf;
in

{

    config = mkIf osConfig.modules.terminal.git.enable {

        programs.git.enable = true;
        programs.git.settings = {
            user.name = osConfig.settings.username;
            user.email = osConfig.settings.mail;
        };
    };
}
