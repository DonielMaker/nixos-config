{
    description = "Please don't use!";

    inputs = {
        # Main Dependencies
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        disko.url = "github:nix-community/disko/latest";
        disko.inputs.nixpkgs.follows = "nixpkgs";

        # Secret Management
        agenix.url = "github:ryantm/agenix";
        agenix.inputs.nixpkgs.follows = "nixpkgs";

        # Styling
        stylix.url = "github:nix-community/stylix";
        stylix.inputs.nixpkgs.follows = "nixpkgs-stable";

        nixos-hardware.url = "github:NixOS/nixos-hardware";
        nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs:

    let 
        system = "x86_64-linux";

        # These might be better stated in an nixos modules (nixpkgs.config || nixpkgs.overlays)?
        pkgs = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
        # pkgs = import inputs.nixpkgs { inherit system overlays; config.allowUnfree = true; config.rocmSupport = true; }; # Only for Comfyui
        pkgs-stable = import inputs.nixpkgs-stable { inherit system; config.allowUnfree = true; };

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
        # Spectre
        nixosConfigurations.spectre = mkNixos ./hosts/spectre;
    };
}
