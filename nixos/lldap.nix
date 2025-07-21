{...}: 

{
    services.lldap.enable = true;
    services.lldap.settings.ldap_base_dn = "dc=thematt,dc=net";
}
