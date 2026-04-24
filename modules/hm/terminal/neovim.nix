{ config, lib, pkgs, ...}:

let
    module = "Neovim";
    cfg = config.modules.hm.neovim;
in with lib;

{
    options.modules.hm.neovim.enable = mkEnableOption "Enable ${module}";

    config = mkIf cfg.enable {

        # Broken because HM tries to set init.lua
        # programs.neovim.enable = true;
        # programs.neovim.defaultEditor = true;

        home.packages = with pkgs; [
            # See above
            neovim

            tree-sitter
            zig
            rustc
            cargo
            nodejs
            gnumake
            openssl
            pkg-config

            # LSP
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
