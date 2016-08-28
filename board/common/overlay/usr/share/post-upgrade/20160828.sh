#!/bin/bash

# more settings have been added to [/data]/etc/os.conf

echo 'os_networkless="false"' >> /data/etc/os.conf
echo 'os_eth="eth0"' >> /data/etc/os.conf
echo 'os_wlan="wlan0"' >> /data/etc/os.conf
echo 'os_ppp="ppp0"' >> /data/etc/os.conf

# boolean values in watch.conf have been normalized to "true" and "false"
sed -i 's/=no/="false"/' /data/etc/watch.conf
sed -i 's/=yes/="true"/' /data/etc/watch.conf

