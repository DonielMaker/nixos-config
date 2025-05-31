rec {
    hostname = "nfs-server";
    system = "x86_64-linux";
    username = "donielmaker";
    dotfiles = "/home/${username}/.config";
    timezone = "Europe/Berlin";
    shell = "bash";
    drive = "/dev/sdb";
}
