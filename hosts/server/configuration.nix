{lib, inputs, pkgs, ...}:

{
    imports = with inputs.self.nixosModules; [
        ./hardware-configuration.nix
        inputs.disko.nixosModules.disko

        # System
        bootloader
        networking
        settings
        user
        disko

        # Hyprland (and other graphics related stuff)
            # graphics

        # Graphics driver
            # intel
            # nvidia
            # amd

        # Display manager
            # gdm
            # sddm

        # Hardware related
            # bluethooth
            # fingerprint
            # sound

        # Programs 
            # neovim
            # openrgb
            # steam
            # zsh
    ];

    services.openssh.enable = true;
    security.sudo.execWheelOnly  =  true;

    users.users.root = {
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith"
        ];
    services.openssh.settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
    };

    # services.stirling-pdf.enable = true;
    # networking.firewall.allowedTCPPorts = [ 22 8080 ];

    nix.settings.trusted-users = [ "donielmaker" ];

    # Any extra Packages
    environment.systemPackages = with pkgs; [
        vim
    ];

    system.stateVersion = "24.11"; # Just don't
}
