{dotfiles, ... }:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        dotDir = ".config/zsh";
        shellAliases = {
            sd = "cd $(find . -type d | fzf)";
            rb = "sudo nixos-rebuild switch --flake ${dotfiles}/nix";
            hm = "home-manager switch --flake ${dotfiles}/nix";
            lg = "lazygit";
            v = "nvim";
            ls = "eza -a --icons=auto";
            ff = "fastfetch";
        };
    };
}
