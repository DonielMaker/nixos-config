{pkgs, dotfiles, ... }:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        dotDir = ".config/zsh";
        shellAliases = {
            rb = "sudo nixos-rebuild switch --flake ${dotfiles}/nix";
            lg = "lazygit";
            v = "nvim";
            ls = "eza -a --icons=auto";
            ff = "fastfetch";
        };
    };
}
