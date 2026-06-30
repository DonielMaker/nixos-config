{ osConfig, ... }:

{

    home = {
        inherit (osConfig.modules.system) username;
        homeDirectory = "/home/${osConfig.modules.system.username}";
        stateVersion = osConfig.system.stateVersion;
    };
}
