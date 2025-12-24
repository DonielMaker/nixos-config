{
    description = "Please don't use!";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

        home-manager.url = "github:nix-community/home-manager/release-25.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        disko.url = "github:nix-community/disko/latest";
        disko.inputs.nixpkgs.follows = "nixpkgs";

        ragenix.url = "github:yaxitech/ragenix";

        stylix.url = "github:nix-community/stylix";
        stylix.inputs.nixpkgs.follows = "nixpkgs";

        copyparty.url = "github:9001/copyparty";

        quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
        quickshell.inputs.nixpkgs.follows = "nixpkgs";

        trilium.url = "github:triliumnext/trilium";
        trilium.inputs.nixpkgs.follows = "nixpkgs";

        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

	    wsl.url = "github:nix-community/NixOS-WSL/main";
    };

    outputs = {...}@inputs:

    let 
        system = "x86_64-linux";

        pkgs = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
        pkgs-stable = import inputs.nixpkgs-stable {inherit system; config.allowUnfree = true;};

        # TODO: Perhaps move these all into one main import file?
        # TODO: mkHome and mkNixos seem very similar is there a way to maybe combine these into one make function?
        mkNixos = import ./lib/mkNixos.nix {inherit inputs system pkgs pkgs-stable myLib;};
        mkHome = import ./lib/mkHome.nix {inherit inputs system pkgs pkgs-stable myLib;};
        buildModules = import ./lib/getModules.nix {lib = inputs.nixpkgs.lib;};
        getSecrets = import ./lib/getSecrets.nix {lib = inputs.nixpkgs.lib;};

        # TODO: like this but maybe a bit better?
        myLib = {inherit mkNixos mkHome buildModules getSecrets;};
    in

    {
        nixosModules = buildModules ./nixos ".nix";
        homeManagerModules = buildModules ./hm ".nix";

        # Main PC
        nixosConfigurations.zenith = mkNixos ./hosts/zenith;
        # Laptop
        nixosConfigurations.galaxia = mkNixos ./hosts/galaxia;
        # Server
        nixosConfigurations.lastprism = mkNixos ./hosts/lastprism;
        # Auth Server
        nixosConfigurations.miasma = mkNixos ./hosts/miasma;
        # Company Server
        nixosConfigurations.srv-mx-02 = mkNixos ./hosts/srv-mx-02;
        # TBC Router
        # nixosConfigurations.vilethorn = mkNixos ./hosts/vilethorn;

        homeConfigurations."donielmaker@zenith" = mkHome ./hosts/zenith;
        homeConfigurations."donielmaker@galaxia" = mkHome ./hosts/galaxia;
        homeConfigurations."donielmaker@wsl" = mkHome ./hosts/wsl;

        nixosConfigurations.wsl = mkNixos ./hosts/wsl;
    };
}
