{
	description = "System configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

		nixos-wsl = {
            url = "github:nix-community/NixOS-WSL/main";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager = {
            url = "github:nix-community/home-manager/";
            inputs.nixpkgs.follows = "nixpkgs";
        };
	};

	outputs = { self, nixpkgs, nixos-wsl, home-manager, ...}:
        let 
            system = "x86_64-linux";
        in {
		nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
            inherit system;
			modules = [
				./nixos/configuration.nix
				nixos-wsl.nixosModules.default {
					system.stateVersion = "24.05";
					wsl.enable = true;
				}
			];
		};

        homeConfigurations.donielmaker = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [ 
                ./home-manager/home.nix
                #./home-manager/oh-my-posh.nix
            ];
        };
    };
}
