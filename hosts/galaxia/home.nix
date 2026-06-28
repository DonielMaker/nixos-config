{ osConfig, ... }:

{

    home = {
        inherit (osConfig.modules.system) username;
        homeDirectory = "/home/${osConfig.modules.system.username}";
        stateVersion = "24.11";
    };
}
