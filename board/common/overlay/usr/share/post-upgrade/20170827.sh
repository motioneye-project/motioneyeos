#!/bin/bash

# add password_hook motioneye setting
grep password_hook /data/etc/motioneye.conf &>/dev/null || echo -e 'password_hook /usr/libexec/meyepasswd' >> /data/etc/motioneye.conf

