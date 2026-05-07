{ config, lib, ... }: 

let
    inherit (lib) mkIf mkEnableOption;
    cfg = config.modules.programs.steam;
in

{
    options.modules.programs.steam.enable = mkEnableOption "Enable Steam";

    config = mkIf cfg.enable {
        programs.steam.enable = true;
        programs.steam.gamescopeSession.enable = true;
        programs.gamescope.enable = true;
        programs.gamemode.enable = true;
    };
}
