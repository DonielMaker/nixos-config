{dotfiles, ... }:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        dotDir = ".config/zsh";
        shellAliases = {
            z = "zellij";
            sd = "cd $(find . -type d | fzf)";
            s = "ragenix -e";
            rb = "sudo nixos-rebuild switch --flake ${dotfiles}/nix";
            hm = "home-manager switch --flake ${dotfiles}/nix";
            lg = "lazygit";
            v = "nvim";
            ls = "eza -a --icons=auto";
            ff = "fastfetch";
        };
    };
}
