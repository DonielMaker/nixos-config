{pkgs, ...}:

{
    # Minecraft server settings
    services.minecraft-servers.enable = true;
    services.minecraft-servers = {
        eula = true;
        openFirewall = true;
        servers.cabin = let
            modpack = pkgs.fetchzip {
                url = "https://github.com/ThePansmith/CABIN/releases/download/2.1.3/CABIN-2.1.3-serverpack.zip";
                hash = "";
            };
        in {
            enable = true;

    # Specify the custom minecraft server package
            package = pkgs.forge.fabric-1_21_1.override {
                loaderVersion = "0.16.10";
            }; # Specific fabric loader version

            symlinks = {
                mods = "${modpack}/mods";
                config = "${modpack}/config";
                ldlib = "${modpack}/ldlib";
                kubejs = "${modpack}/kubejs";
            };
        };
    };
}
