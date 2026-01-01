{ username, mail, ...}:

{
    programs.git.enable = true;
    programs.git.settings = {
        user.name = username;
        user.email = mail;
    };
}
