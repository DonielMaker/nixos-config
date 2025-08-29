{...}: 

{
    services.lldap.enable = true;
    services.lldap.settings.ldap_base_dn = "dc=thematt,dc=net";
    # User does no longer exist
    services.lldap.settings.ldap_user_pass = "blablabla";
    networking.firewall.allowedTCPPorts = [ 17170 3890 ];
    services.lldap.silenceForceUserPassResetWarning = true;
}
