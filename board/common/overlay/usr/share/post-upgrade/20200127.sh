#!/bin/bash

# SSH config files and keys have been moved from /data/etc/ to /data/etc/ssh
mkdir -p /data/etc/ssh
test -f /data/etc/ssh_authorized_keys && mv /data/etc/ssh_authorized_keys /data/etc/ssh/authorized_keys
test -f /data/etc/sshd_config && mv /data/etc/sshd_config /data/ssh/etc
test -f /data/etc/sshd_id_rsa && mv /data/etc/ssh_id_rsa /data/ssh/etc
test -f /data/etc/sshd_id_rsa.pub && mv /data/etc/ssh_id_rsa.pub /data/ssh/etc
mv /data/etc/ssh_host* /data/etc/ssh
