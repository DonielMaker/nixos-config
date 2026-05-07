{ config, lib, pkgs, ...}:

let
    inherit (lib) mkEnableOption mkIf;
    cfg = config.modules.terminal.neovim;
in

{
    options.modules.terminal.neovim.enable = mkEnableOption "Enable Neovim";

    config = mkIf cfg.enable {

        programs.neovim.enable = true;
        programs.neovim.defaultEditor = true;

        home-manager.users.${config.modules.system.username} = {

            home.packages = with pkgs; [
                # Needed by Treesitter
                # tree-sitter # only for Grammar? Check if issues occur: if so reenable it.
                zig
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
    };
}
