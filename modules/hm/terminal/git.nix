{ config, lib, ...}:

let
    module = "Git";
    cfg = config.modules.hm.git;
in with lib;

{
    options.modules.hm.git.enable = mkEnableOption "Enable ${module}";

    config = mkIf cfg.enable {

        programs.git.enable = true;
        programs.git.settings = {
            user.name = config.modules.hm.username;
            user.email = config.modules.hm.mail;
        };
    };
}
