{pkgs, username, ...}: 

{
    virtualisation.containers.enable = true;
    virtualisation.docker.enable = true;
    users.users.${username}.extraGroups = ["docker"];

    environment.systemPackages = with pkgs; [
        docker-compose
    ];
}
