################################################################################
#
# ndisc6
#
################################################################################

NDISC6_VERSION = 1.0.2
NDISC6_SOURCE = ndisc6-$(NDISC6_VERSION).tar.bz2
NDISC6_SITE = http://www.remlab.net/files/ndisc6
NDISC6_CONF_ENV = CC="$(TARGET_CC) -std=gnu99" LIBS=$(TARGET_NLS_LIBS)
NDISC6_CONF_OPTS = --disable-rpath --disable-suid-install
NDISC6_LICENSE = GPL-2.0 or GPL-3.0
NDISC6_LICENSE_FILES = COPYING
NDISC8_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)

NDISC6_BIN_ += dnssort # perl script
NDISC6_BIN_$(BR2_PACKAGE_NDISC6_NAME2ADDR) += name2addr addr2name
NDISC6_BIN_$(BR2_PACKAGE_NDISC6_TCPSPRAY) += tcpspray tcpspray6

NDISC6_SBIN_$(BR2_PACKAGE_NDISC6_NDISC6) += ndisc6
NDISC6_SBIN_$(BR2_PACKAGE_NDISC6_RDISC6) += rdisc6
NDISC6_SBIN_$(BR2_PACKAGE_NDISC6_RDNSSD) += rdnssd
NDISC6_SBIN_$(BR2_PACKAGE_NDISC6_RLTRACEROUTE6) += rltraceroute6 tracert6
NDISC6_SBIN_$(BR2_PACKAGE_NDISC6_TCPTRACEROUTE6) += tcptraceroute6

define NDISC6_REMOVE_UNNEEDED
	rm -rf $(addprefix $(TARGET_DIR)/usr/bin/,$(NDISC6_BIN_)) \
		$(addprefix $(TARGET_DIR)/usr/sbin/,$(NDISC6_SBIN_))
	$(if $(BR2_PACKAGE_NDISC6_RDNSSD),,\
		rm -rf $(TARGET_DIR)/etc/rdnssd $(TARGET_DIR)/var/run/rdnssd)
endef

NDISC6_POST_INSTALL_TARGET_HOOKS += NDISC6_REMOVE_UNNEEDED

$(eval $(autotools-package))
