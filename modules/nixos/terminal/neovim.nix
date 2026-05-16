{ config, lib, ...}:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.neovim;
in

{
    options.modules.terminal.neovim.enable = mkEnableOption "Enable Neovim";

    config = mkIf cfg.enable {

        programs.neovim.enable = true;
        programs.neovim.defaultEditor = true;
    };
}
