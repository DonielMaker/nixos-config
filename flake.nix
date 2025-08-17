{
    description = "Please don't use!";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        disko.url = "github:nix-community/disko/latest";
        disko.inputs.nixpkgs.follows = "nixpkgs";

	    # wsl.url = "github:nix-community/NixOS-WSL/main";

        quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
        quickshell.inputs.nixpkgs.follows = "nixpkgs";

        ragenix.url = "github:yaxitech/ragenix";
    };

    outputs = {...}@inputs:

    let 
        system = "x86_64-linux";

        pkgs = import inputs.nixpkgs {inherit system; config.allowUnfree = true;};
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
        nixosModules = buildModules ./nixos;
        homeManagerModules = buildModules ./hm;

        # Main PC
        nixosConfigurations.zenith = mkNixos ./hosts/zenith;
        # Laptop
        nixosConfigurations.galaxia = mkNixos ./hosts/galaxia;
        # Auth Server
        nixosConfigurations.lastprism = mkNixos ./hosts/lastprism;

        nixosConfigurations.lastprism-max = mkNixos ./hosts/lastprism-max;
        # TBC Router
        # nixosConfigurations.vilethorn = mkNixos ./hosts/vilethorn;

        # TODO: Do we want a single user for all systems or one for each?
        # INFO: Considering how we fetch the home.nix and settings.nix with the settingsPath 
        # it might be better to have one homeConfigurations per device.
        # This could be achieved by using "donielmaker@${system}" for each
        # individual homeConfigurations.
        # PASSED: This has been resolved like this:
        homeConfigurations."donielmaker@zenith" = mkHome ./hosts/zenith;
        homeConfigurations."donielmaker@galaxia" = mkHome ./hosts/galaxia;

        # DEPRECATED for now
        # nixosConfigurations.wsl = mkNixos ./hosts/wsl;

        # devShells.${system} = {
        #     rust = (import ./testing/rust.nix {inherit pkgs;});
        # };
    };
}
