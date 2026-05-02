{config, pkgs, ...}:

{
    # Home-Assistant: Home Automation
    services.home-assistant.enable = true;
    services.home-assistant = {
        extraComponents = [
            "analytics"
            "met"
            "isal"
            "mqtt"
        ];

        customComponents = with pkgs.home-assistant-custom-components; [
            auth_oidc
            prometheus_sensor
        ];

        config = {
            # Includes dependencies for a basic setup
            # https://www.home-assistant.io/integrations/default_config/
            default_config = {};
            homeassistant = {
                name = "Home";
                latitude = "53.00906288742223";
                longitude = "9.060134791016266";
                unit_system = "metric";
                time_zone = "Europe/Berlin";
            };
            http = {
                use_x_forwarded_for = true;
                # Why Can't this be dns?
                trusted_proxies = [ "10.10.12.10" "fd70:239a:df9e:0::/64" ]; 
            };
        };
    };

    # Mosquitto: Mqtt Server
    services.mosquitto.enable = true;
    services.mosquitto = {
        # listeners = [
        #     {
        #         acl = [ "pattern readwrite #" ];
        #         omitPasswordAuth = true;
        #         settings.allow_anonymous = true;
        #     }
        # ];
        listeners = [
            {  
                users.iot = {
                    acl = [

                        "readwrite zigbee2mqtt/#"
                            "readwrite homeassistant/#"
                            "readwrite IoT/#"
                    ];
                    # acl = [
                    #     "read IoT/device/action"
                    #     "write IoT/device/observations"
                    #     "write IoT/device/LW"
                    # ];
                    passwordFile = config.age.secrets.mosquitto-iotPassword.path;
                };
            }
        ];
    };

    # Zigbee2mqtt: Connection between Zigbee and Mqtt devices
    services.zigbee2mqtt.enable = true;
    services.zigbee2mqtt = {
        settings = {
            homeassistant.enabled = config.services.home-assistant.enable;
            frontend.enabled = true;
            permit_join = true;
            serial = {
                port = "/dev/ttyUSB0";
            };
            mqtt = {
                server = "mqtt://lastprism.thematt.net:1883";
                user = "iot";
                password = "2nkFzRMG#l4sxXsUrctHQ&%UcD6ZCc&HIG3vMPxmOfX0VIgvY2HeE5m&&eWbXr^T";
            };
        };
    };
}
