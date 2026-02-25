{
    description = "Please don't use!";

    inputs = {
        # Main Dependencies
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        disko.url = "github:nix-community/disko/latest";
        disko.inputs.nixpkgs.follows = "nixpkgs";

        # Secret Management
        ragenix.url = "github:yaxitech/ragenix";
        ragenix.inputs.nixpkgs.follows = "nixpkgs";

        # Styling
        stylix.url = "github:nix-community/stylix";
        stylix.inputs.nixpkgs.follows = "nixpkgs";

        # For now only firefox-addons
        nur.url = "github:nix-community/NUR";
        nur.inputs.nixpkgs.follows = "nixpkgs";

        # These are program flakes
        copyparty.url = "github:9001/copyparty";
        copyparty.inputs.nixpkgs.follows = "nixpkgs";

        quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
        quickshell.inputs.nixpkgs.follows = "nixpkgs";

        authentik-nix.url = "github:nix-community/authentik-nix";

        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
        neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = {...}@inputs:

    let 
        system = "x86_64-linux";

        # These might be better stated in an nixos modules (nixpkgs.config || nixpkgs.overlays)?
        pkgs = import inputs.nixpkgs { inherit system overlays; config.allowUnfree = true; };
        pkgs-stable = import inputs.nixpkgs-stable {inherit system overlays; config.allowUnfree = true;};
        overlays = with inputs; [
            neovim-nightly-overlay.overlays.default
            nur.overlays.default
        ];

        sLib = import ./lib {inherit inputs pkgs pkgs-stable;};
        inherit (sLib) mkNixos;
    in

    {
        # Desktop
        nixosConfigurations.zenith = mkNixos ./hosts/zenith;
        # Laptop
        nixosConfigurations.galaxia = mkNixos ./hosts/galaxia;
        # Storage Server
        nixosConfigurations.lastprism = mkNixos ./hosts/lastprism;
        # Auth Server
        nixosConfigurations.miasma = mkNixos ./hosts/miasma;
    };
}
