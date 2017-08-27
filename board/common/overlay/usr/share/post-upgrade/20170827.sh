#!/bin/bash

# create the persisted /var/lib directory (/data/varlib)
mkdir -p /data/varlib

# add password_hook motioneye setting
grep password_hook /data/etc/motioneye.conf &>/dev/null || echo -e 'password_hook /usr/libexec/meyepasswd' >> /data/etc/motioneye.conf

