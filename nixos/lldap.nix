{...}: 

{
    services.lldap.enable = true;
    services.lldap.settings.ldap_base_dn = "dc=thematt,dc=net";
    networking.firewall.allowedTCPPorts = [ 17170 3890 ];
}
