{pkgs, pkgs-stable, ...}:

{
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;

    environment.systemPackages = with pkgs; [
        neovim

        # Programming Stuff
        tree-sitter
        zig
        pkgs.rustc
        cargo
        nodejs
        gnumake
        openssl
        pkg-config
        # texliveFull

        # LSP
        marksman
        # texlab
        lua-language-server
        rust-analyzer
        # tinymist
        yaml-language-server
        # nil
        nixd
        # slint-lsp
        typescript-language-server
        bash-language-server
        vscode-langservers-extracted
    ];
}
