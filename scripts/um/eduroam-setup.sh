#!/bin/bash
 
CONNAME="eduroam"
 
nmcli connection add type wifi con-name $CONNAME        \
        802-11-wireless.ssid $CONNAME                   \
        802-11-wireless-security.key-mgmt wpa-eap       \
        802-1x.eap peap                                 \
        802-1x.identity $USERNAME                       \
        802-1x.password $PASSWORD                       \
        802-1x.phase2-auth mschapv2                     \
        802-11-wireless.powersave 2                     \
