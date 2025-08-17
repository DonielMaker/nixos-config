{pkgs, username, shell, ...}:

{
    users.users.${username} = {
        isNormalUser = true;
        description = username;
        extraGroups = ["networkmanager" "wheel" "input" "audio"];
        shell = pkgs.${shell};
        initialPassword = "Changeme";
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEwosE68FthKwXs1WhPnY3YqbkVPT52V30X489epRsJQ donielmaker@zenith"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGCA4si0+PqWQn/PRtfOeuCIK3ISIvMKfvQhciwPQvh donielmaker@galaxia"
        ];
    };
}
