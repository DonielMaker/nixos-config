{config, ... }:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        shellAliases = {
            nr = "nixos-rebuild switch --sudo --ask-sudo-password";
            z = "zellij";
            s = "ragenix -e";
            rb = "sudo nixos-rebuild switch --flake ${config.xdg.configHome}/nix";
            hm = "home-manager switch --flake ${config.xdg.configHome}/nix";
            lg = "lazygit";
            v = "nvim";
            ls = "eza -a --icons=auto";
            ff = "fastfetch";
        };
    };
}
