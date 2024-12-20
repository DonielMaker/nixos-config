{  
    imports = [ ./hardware-configuration.nix ];

    # boot.supportedFilesystems = [ "ntfs" ];

    # services.devmon.enable = true;
    # services.gvfs.enable = true; 
    # services.udisks2.enable = true;

    #services.openssh.enable = true;

    networking.networkmanager.enable = true;
    networking.hostName = "galaxia";

    time.timeZone = "Europe/Berlin";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # For Zsh Auto Completion
    environment.pathsToLink = [ "/share/zsh" ];
    programs.zsh.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
