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

        environment.systemPackages = with pkgs; [
            zig # Needed by Treesitter

            # == Dependencies == 
            fd
            fzf
            git
            ripgrep

            # == LSPs ==
            bash-language-server # Bash, sh
            just-lsp # Just
            lua-language-server # Lua
            marksman # Markdown
            nixd # Nix
            rust-analyzer # Rust
            tinymist # Typst
            websocat # Required by Typst-Live-Preview
            vscode-langservers-extracted # Html, Css, Json
            vtsls # Js, Ts
            yaml-language-server # Yaml
        ];
    };
}
