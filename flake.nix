{
    description = "Please don't use!";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        disko.url = "github:nix-community/disko/latest";
        disko.inputs.nixpkgs.follows = "nixpkgs";

        walker.url = "github:abenz1267/walker/v0.12.21";

        stylix.url = "github:nix-community/stylix";

	    # wsl.url = "github:nix-community/NixOS-WSL/main";
    };

    outputs = {...}@inputs :

    let 
        system = "x86_64-linux";

        pkgs = import inputs.nixpkgs {inherit system overlays; config.allowUnfree = true;};
        pkgs-stable = import inputs.nixpkgs-stable {inherit system overlays; config.allowUnfree = true;};

        overlays = import ./nixos/overlays.nix {inherit pkgs;}; 
        mkNixos = import ./lib/mkNixos.nix {inherit inputs system pkgs pkgs-stable;};
        buildModules = import ./lib/getModules.nix {lib = inputs.nixpkgs.lib;};
    in

    {
        nixosModules = buildModules ./nixos;
        homeManagerModules = buildModules ./hm;

        nixosConfigurations.galaxia = mkNixos ./hosts/galaxia {useHM = true;};
        nixosConfigurations.zenith = mkNixos ./hosts/zenith {useHM = true;};
        nixosConfigurations."server" = mkNixos ./hosts/server {useHM = false;};
        nixosConfigurations.lastprism = mkNixos ./hosts/lastprism {useHM = false;};

        # DEPRECATED for now
        # nixosConfigurations.wsl = mkNixos ./hosts/wsl;

        devShells.${system} = {
            rust = (import ./testing/rust.nix {inherit pkgs;});
            test = (import ./testing/fhs.nix {inherit pkgs;});
        };
    };
}
