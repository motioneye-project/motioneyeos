#!/bin/sh

if [ -z "${TARGET}" ]; then
    echo "this script must be invoked from postscript.sh"
    exit 1
fi

find ${TARGET} -name '.empty' | xargs -r rm

# /etc stuff
rm -rf ${TARGET}/etc/network/
rm -rf ${TARGET}/etc/dhcp/
rm -rf ${TARGET}/etc/rc_keymaps/
rm -rf ${TARGET}/etc/default/
rm -rf ${TARGET}/etc/ctdb/
rm -rf ${TARGET}/etc/sudoers.d/
rm -rf ${TARGET}/etc/ssl/man
rm -rf ${TARGET}/etc/ssl/misc
rm -rf ${TARGET}/etc/ssl/private
rm -rf ${TARGET}/etc/logrotate.d
rm -rf ${TARGET}/etc/fstab

rm -f ${TARGET}/etc/rc_maps.cfg
rm -f ${TARGET}/etc/udev/hwdb.d/20-pci-vendor-model.hwdb
rm -f ${TARGET}/etc/hostname
rm -f ${TARGET}/etc/os-release
rm -f ${TARGET}/etc/hostapd.conf
rm -f ${TARGET}/etc/timezone

# /usr/share stuff
rm -rf ${TARGET}/usr/share/bash-completion/
rm -rf ${TARGET}/usr/share/locale/*
rm -rf ${TARGET}/usr/share/ffmpeg/
rm -rf ${TARGET}/usr/share/perl5/
rm -rf ${TARGET}/usr/share/common-lisp/

# various binaries
rm -f ${TARGET}/bin/more
rm -f ${TARGET}/bin/wdctl
rm -f ${TARGET}/usr/sbin/readprofile
rm -f ${TARGET}/sbin/nologin
rm -f ${TARGET}/bin/mountpoint
rm -f ${TARGET}/sbin/ldattach
rm -f ${TARGET}/usr/sbin/ldattach
rm -f ${TARGET}/sbin/slattach
rm -f ${TARGET}/sbin/plipconfig
rm -f ${TARGET}/sbin/fstrim
rm -f ${TARGET}/usr/sbin/rtcwake
rm -f ${TARGET}/bin/lsblk
rm -f ${TARGET}/usr/bin/col
rm -f ${TARGET}/sbin/fdformat
rm -f ${TARGET}/sbin/ctrlaltdel
rm -f ${TARGET}/bin/findmnt
rm -f ${TARGET}/usr/bin/colcrt
rm -f ${TARGET}/sbin/fsfreeze
rm -f ${TARGET}/usr/bin/colrm
rm -f ${TARGET}/usr/sbin/addpart
rm -f ${TARGET}/sbin/blkdiscard
rm -f ${TARGET}/usr/sbin/delpart
rm -f ${TARGET}/usr/bin/column
rm -f ${TARGET}/sbin/swapon
rm -f ${TARGET}/usr/sbin/resizepart
rm -f ${TARGET}/usr/bin/hexdump
rm -f ${TARGET}/sbin/swapoff
rm -f ${TARGET}/usr/bin/rev
rm -f ${TARGET}/sbin/chcpu
rm -f ${TARGET}/usr/bin/tailf
rm -f ${TARGET}/usr/bin/pg
rm -f ${TARGET}/sbin/blkid
rm -f ${TARGET}/usr/bin/ul
rm -f ${TARGET}/sbin/findfs
rm -f ${TARGET}/sbin/wipefs
rm -f ${TARGET}/usr/bin/script
rm -f ${TARGET}/usr/bin/scriptreplay
rm -f ${TARGET}/sbin/fsck.minix
rm -f ${TARGET}/sbin/mkfs.minix
rm -f ${TARGET}/usr/bin/setterm
rm -f ${TARGET}/usr/bin/flock
rm -f ${TARGET}/sbin/mkfs
rm -f ${TARGET}/usr/bin/ipcmk
rm -f ${TARGET}/sbin/mkfs.bfs
rm -f ${TARGET}/usr/bin/ipcrm
rm -f ${TARGET}/usr/bin/ipcs
rm -f ${TARGET}/sbin/mkswap
rm -f ${TARGET}/usr/bin/renice
rm -f ${TARGET}/sbin/swaplabel
rm -f ${TARGET}/usr/bin/setsid
rm -f ${TARGET}/sbin/blockdev
rm -f ${TARGET}/usr/bin/cytune
rm -f ${TARGET}/usr/bin/setarch
rm -f ${TARGET}/sbin/sfdisk
rm -f ${TARGET}/usr/bin/prlimit
rm -f ${TARGET}/sbin/cfdisk
rm -f ${TARGET}/usr/bin/lscpu
rm -f ${TARGET}/usr/bin/unshare
rm -f ${TARGET}/usr/bin/nsenter
rm -f ${TARGET}/usr/bin/cal
rm -f ${TARGET}/usr/bin/look
rm -f ${TARGET}/usr/bin/mcookie
rm -f ${TARGET}/usr/bin/namei
rm -f ${TARGET}/usr/bin/whereis
rm -f ${TARGET}/usr/bin/lslocks
rm -f ${TARGET}/usr/bin/uuidgen
rm -f ${TARGET}/usr/bin/getopt
rm -f ${TARGET}/bin/isosize
rm -f ${TARGET}/usr/sbin/fdformat
rm -f ${TARGET}/usr/bin/linux32
rm -f ${TARGET}/usr/bin/linux64
rm -f ${TARGET}/usr/bin/uname26
rm -f ${TARGET}/bin/zcat
rm -f ${TARGET}/bin/zcmp
rm -f ${TARGET}/bin/zdiff
rm -f ${TARGET}/bin/zegrep
rm -f ${TARGET}/bin/zfgrep
rm -f ${TARGET}/bin/zforce
rm -f ${TARGET}/bin/zgrep
rm -f ${TARGET}/bin/zless
rm -f ${TARGET}/bin/zmore
rm -f ${TARGET}/bin/znew
rm -f ${TARGET}/bin/gzexe
rm -f ${TARGET}/bin/uncompress
rm -f ${TARGET}/usr/bin/slogin
rm -f ${TARGET}/usr/bin/ssh-keyscan
rm -f ${TARGET}/usr/bin/ssh-add
rm -f ${TARGET}/usr/bin/ssh-agent
rm -f ${TARGET}/usr/bin/xmllint

rm -f ${TARGET}/usr/libexec/ssh-keysign
rm -f ${TARGET}/usr/libexec/ssh-pkcs11-helper
rm -f ${TARGET}/usr/libexec/rmt

# samba4 unneeded stuff
rm -f ${TARGET}/usr/bin/cifsdd
rm -f ${TARGET}/usr/bin/containers_*
rm -f ${TARGET}/usr/bin/ctdb*
rm -f ${TARGET}/usr/bin/dbwrap_tool
rm -f ${TARGET}/usr/bin/eventlogadm
rm -f ${TARGET}/usr/bin/event_rpcgen.py
rm -f ${TARGET}/usr/bin/gentest
rm -f ${TARGET}/usr/bin/ldb*
rm -f ${TARGET}/usr/bin/locktest
rm -f ${TARGET}/usr/bin/ltdbtool
rm -f ${TARGET}/usr/bin/masktest
rm -f ${TARGET}/usr/bin/ndrdump
rm -f ${TARGET}/usr/bin/net
rm -f ${TARGET}/usr/bin/ntdb*
rm -f ${TARGET}/usr/bin/ntlm_auth
rm -f ${TARGET}/usr/bin/oLschema2ldif
rm -f ${TARGET}/usr/bin/onnode
rm -f ${TARGET}/usr/bin/pdbedit
rm -f ${TARGET}/usr/bin/pidl
rm -f ${TARGET}/usr/bin/ping_pong
rm -f ${TARGET}/usr/bin/profiles
rm -f ${TARGET}/usr/bin/reg*
rm -f ${TARGET}/usr/bin/rpcclient
rm -f ${TARGET}/usr/bin/samba-regedit
rm -f ${TARGET}/usr/bin/sharesec
rm -f ${TARGET}/usr/bin/smbcacls
rm -f ${TARGET}/usr/bin/smbcontrol
rm -f ${TARGET}/usr/bin/smbcquotas
rm -f ${TARGET}/usr/bin/smbget
rm -f ${TARGET}/usr/bin/smbspool
rm -f ${TARGET}/usr/bin/smbstatus
rm -f ${TARGET}/usr/bin/smbta-util
rm -f ${TARGET}/usr/bin/smbtar
rm -f ${TARGET}/usr/bin/smbtree
rm -f ${TARGET}/usr/bin/smnotify
rm -f ${TARGET}/usr/bin/tdb*
rm -f ${TARGET}/usr/bin/testparm
rm -f ${TARGET}/usr/bin/wbinfo
rm -f ${TARGET}/usr/sbin/winbindd
rm -rf ${TARGET}/usr/share/ctdb

# unused mongodb binaries
rm -f ${TARGET}/usr/bin/mongos
rm -f ${TARGET}/usr/bin/mongoperf

# unused redis binaries
rm -f $TARGET/usr/bin/redis-check-aof
rm -f $TARGET/usr/bin/redis-check-rdb
rm -f $TARGET/usr/bin/redis-benchmark
rm -f $TARGET/usr/bin/redis-cli
rm -f $TARGET/usr/bin/redis-sentinel

# v4l-utils
rm -f ${TARGET}/usr/bin/cec-compliance
rm -f ${TARGET}/usr/bin/cec-ctl
rm -f ${TARGET}/usr/bin/cec-follower
rm -f ${TARGET}/usr/bin/dvb-fe-tool
rm -f ${TARGET}/usr/bin/dvb-format-convert
rm -f ${TARGET}/usr/bin/dvbv5-daemon
rm -f ${TARGET}/usr/bin/dvbv5-scan
rm -f ${TARGET}/usr/bin/dvbv5-zap
rm -f ${TARGET}/usr/bin/media-ctl
rm -f ${TARGET}/usr/bin/rds-ctl
rm -f ${TARGET}/usr/bin/v4l2-compliance

# unused python folders
rm -rf ${TARGET}/usr/lib/python2.7/site-packages/samba/
rm -rf ${TARGET}/usr/lib/python2.7/ensurepip/
rm -rf ${TARGET}/usr/lib/python2.7/config/
rm -rf ${TARGET}/usr/lib/python2.7/unittest/

# buildroot default startup scripts
rm -f ${TARGET}/etc/init.d/S01syslogd
rm -f ${TARGET}/etc/init.d/S10udev
rm -f ${TARGET}/etc/init.d/S15watchdog
rm -f ${TARGET}/etc/init.d/S20urandom
rm -f ${TARGET}/etc/init.d/S21rngd
rm -f ${TARGET}/etc/init.d/S48sntp
rm -f ${TARGET}/etc/init.d/S49ntp
rm -f ${TARGET}/etc/init.d/S50sshd
rm -f ${TARGET}/etc/init.d/S50proftpd
rm -f ${TARGET}/etc/init.d/S50postgresql
rm -f ${TARGET}/etc/init.d/S50redis
rm -f ${TARGET}/etc/init.d/S80dhcp-relay
rm -f ${TARGET}/etc/init.d/S80dhcp-server
rm -f ${TARGET}/etc/init.d/S80dnsmasq
rm -f ${TARGET}/etc/init.d/S91smb
rm -f ${TARGET}/etc/init.d/S99motion

# other unwanted dirs
rm -rf ${TARGET}/data/*
rm -rf ${TARGET}/run
rm -rf ${TARGET}/etc/profile.d
