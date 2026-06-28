{ config, lib, pkgs, ... }:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.neovim;
in

{
    options.modules.terminal.neovim.enable = mkEnableOption "Enable Neovim";

    config = mkIf cfg.enable {

        programs.neovim.enable = true;
        programs.neovim.defaultEditor = true;

        users.users.${config.modules.system.username}.packages = with pkgs; [
            # Needed by Treesitter
            zig
            # These are most likely not needed and should be in devenv/devshells
            rustc
            cargo
            nodejs
            # gnumake
            # openssl
            # pkg-config

            # Needed by certain plugins
            fzf
            fd
            ripgrep
            git

            # LSPs
            marksman
            yaml-language-server
            lua-language-server
            rust-analyzer
            yaml-language-server
            nixd
            bash-language-server
            vscode-langservers-extracted
            vtsls
            kdePackages.qtdeclarative
            just-lsp
            tinymist
        ];
    };
}
