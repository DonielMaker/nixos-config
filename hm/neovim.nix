{pkgs, ...}:

{
    programs.neovim = {
        enable = true;
        defaultEditor = true;
        extraLuaPackages = ps: [ ps.magick ];
        extraPackages = [ pkgs.imagemagick ];
        plugins = with pkgs.vimPlugins.nvim-treesitter-parsers; [
            # latex
            json
            javascript
            tsx
            yaml
            yuck
            html
            css
            markdown
            markdown_inline
            bash
            lua
            gitignore
            query
            c
            rust
            regex
            slint
            typst
        ];
    };

    home.packages = with pkgs; [
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
        # typescript-language-server
        # tinymist
        # slint-lsp
    ];
}
