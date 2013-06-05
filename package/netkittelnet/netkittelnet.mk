################################################################################
#
# netkittelnet
#
################################################################################

NETKITTELNET_VERSION = 0.17
NETKITTELNET_SOURCE  = netkit-telnet-$(NETKITTELNET_VERSION).tar.gz
NETKITTELNET_SITE    = ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/
NETKITTELNET_LICENSE = BSD-4c
NETKITTELNET_DEPENDENCIES = netkitbase

define NETKITTELNET_CONFIGURE_CMDS
	# use ANSI syntax
	$(SED) "s/main()/main(void)/;" $(@D)/configure
	# Disable termcap support
	$(SED) "s~\(.*termcap\.h.*\)~/* \1 */~;" $(@D)/telnetd/telnetd.c
	# C++ support not needed for telnetd
	$(SED) 's/CXX/CC/g' -e 's/conftest.cc/conftest.c/g' $(@D)/configure
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		--installroot=$(TARGET_DIR))
endef

define NETKITTELNET_BUILD_CMDS
	$(MAKE) SUB=telnetd -C $(@D)
endef

define NETKITTELNET_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/telnetd/telnetd $(TARGET_DIR)/usr/sbin/telnetd
	# Enable telnet in inetd
	$(SED) "s~^#telnet.*~telnet\tstream\ttcp\tnowait\troot\t/usr/sbin/telnetd\t/usr/sbin/telnetd~;" $(TARGET_DIR)/etc/inetd.conf
endef

$(eval $(generic-package))
