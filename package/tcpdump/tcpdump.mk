################################################################################
#
# tcpdump
#
################################################################################

TCPDUMP_VERSION = 4.6.1
TCPDUMP_SITE = http://www.tcpdump.org/release
TCPDUMP_LICENSE = BSD-3c
TCPDUMP_LICENSE_FILES = LICENSE
TCPDUMP_CONF_ENV = ac_cv_linux_vers=2 td_cv_buggygetaddrinfo=no
TCPDUMP_CONF_OPT = --without-crypto \
		$(if $(BR2_PACKAGE_TCPDUMP_SMB),--enable-smb,--disable-smb)
TCPDUMP_DEPENDENCIES = zlib libpcap

# make install installs an unneeded extra copy of the tcpdump binary
define TCPDUMP_REMOVE_DUPLICATED_BINARY
	rm -f $(TARGET_DIR)/usr/sbin/tcpdump.$(TCPDUMP_VERSION)
endef

TCPDUMP_POST_INSTALL_TARGET_HOOKS += TCPDUMP_REMOVE_DUPLICATED_BINARY

$(eval $(autotools-package))
