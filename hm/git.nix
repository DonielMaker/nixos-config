{ username, mail, ...}:

{
    programs.git.settings = {
        enable = true;
        userName = username;
        userEmail = mail;
    };
}
