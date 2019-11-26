#!/usr/bin/env bash

IPK_BUILD=${BUILD_DIR}/ipk-build

# Pull the files for the snmpd service out of the target to create a install archive
# and setup a basic configuration so that the startup script works.
mkdir -p ${IPK_BUILD}/CONTROL \
	${IPK_BUILD}/etc/init.d/ \
	${IPK_BUILD}/usr/sbin \
	${IPK_BUILD}/etc/snmp \
	${IPK_BUILD}/etc/default
mv -f ${TARGET_DIR}/etc/init.d/S59snmpd ${IPK_BUILD}/etc/init.d/
mv -f ${TARGET_DIR}/usr/sbin/snmpd ${IPK_BUILD}/usr/sbin/
echo "agentuser  nobody" > ${IPK_BUILD}/etc/snmp/snmpd.conf
echo "SNMPDRUN=yes" > ${IPK_BUILD}/etc/default/snmpd

# build the control file
cat <<EOM >${IPK_BUILD}/CONTROL/control
Package: example-snmpd-package
Version: 1.0
Architecture: arm
Maintainer: user@domain.tld
Section: extras
Priority: optional
Source: http://example.com
Description: This is an example IPK package for installing snmpd
EOM

# preinst script is not created to run before the install for this test example

# postinst script is ran after install completes to start the services
cat <<EOM >${IPK_BUILD}/CONTROL/postinst
#!/bin/sh
/etc/init.d/S59snmpd start
EOM
chmod +x ${IPK_BUILD}/CONTROL/postinst

# prerm script is ran before removal so that the services isn't in use
cat <<EOM >${IPK_BUILD}/CONTROL/prerm
#!/bin/sh
/etc/init.d/S59snmpd stop
EOM
chmod +x ${IPK_BUILD}/CONTROL/prerm

# build the archive from template and pkg files
${HOST_DIR}/bin/opkg-build -Z gzip ${IPK_BUILD} ${TARGET_DIR}/root/
rm -fr ${IPK_BUILD}
