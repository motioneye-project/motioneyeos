#############################################################
#
# ndisc6
#
#############################################################

NDISC6_VERSION = 1.0.2
NDISC6_SOURCE = ndisc6-$(NDISC6_VERSION).tar.bz2
NDISC6_SITE = http://www.remlab.net/files/ndisc6/
NDISC6_CONF_ENV = CC="$(TARGET_CC) -std=gnu99"
NDISC6_CONF_OPT = --localstatedir=/var --disable-rpath --disable-suid-install

ifeq ($(BR2_PACKAGE_LIBINTL),y)
NDISC6_DEPENDENCIES += libintl
NDISC6_CONF_ENV += LDFLAGS="$(TARGET_LDFLAGS) -lintl"
endif

NDISC6_BIN_ += dnssort # perl script
NDISC6_BIN_$(BR2_PACKAGE_NDISC6_NAME2ADDR) += name2addr addr2name
NDISC6_BIN_$(BR2_PACKAGE_NDISC6_TCPSPRAY) += tcpspray tcpspray6

NDISC6_SBIN_$(BR2_PACKAGE_NDISC6_NDISC6) += ndisc6
NDISC6_SBIN_$(BR2_PACKAGE_NDISC6_RDISC6) += rdisc6
NDISC6_SBIN_$(BR2_PACKAGE_NDISC6_RDNSSD) += rdnssd
NDISC6_SBIN_$(BR2_PACKAGE_NDISC6_RLTRACEROUTE6) += rltraceroute6 tracert6
NDISC6_SBIN_$(BR2_PACKAGE_NDISC6_TCPTRACEROUTE6) += tcptraceroute6

NDISC6_MAN1_ = $(addsuffix .1,$(NDISC6_BIN_))
NDISC6_MAN8_ = $(addsuffix .8,$(NDISC6_SBIN_))

define NDISC6_REMOVE_UNNEEDED
	rm -rf $(addprefix $(TARGET_DIR)/usr/bin/,$(NDISC6_BIN_)) \
	       $(addprefix $(TARGET_DIR)/usr/sbin/,$(NDISC6_SBIN_)) \
	       $(addprefix $(TARGET_DIR)/usr/share/man/man1/,$(NDISC6_MAN1_)) \
	       $(addprefix $(TARGET_DIR)/usr/share/man/man8/,$(NDISC6_MAN8_))
	$(if $(BR2_PACKAGE_NDISC6_RDNSSD),,\
		rm -rf $(TARGET_DIR)/etc/rdnssd $(TARGET_DIR)/var/run/rdnssd)
endef

NDISC6_POST_INSTALL_TARGET_HOOKS += NDISC6_REMOVE_UNNEEDED

$(eval $(autotools-package))
