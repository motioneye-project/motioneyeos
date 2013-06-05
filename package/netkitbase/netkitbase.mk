################################################################################
#
# netkitbase
#
################################################################################

NETKITBASE_VERSION = 0.17
NETKITBASE_SOURCE  = netkit-base-$(NETKITBASE_VERSION).tar.gz
NETKITBASE_SITE    = ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/
NETKITBASE_LICENSE = BSD-4c

define NETKITBASE_CONFIGURE_CMDS
	# use ANSI syntax
	$(SED) "s/main()/main(void)/;" $(NETKITBASE_DIR)/configure
	# don't try to run cross compiled binaries while configuring things
	$(SED) "s~./__conftest~#./__conftest~;" $(NETKITBASE_DIR)/configure
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		--installroot=$(TARGET_DIR))
endef

define NETKITBASE_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define NETKITBASE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/inetd/inetd $(TARGET_DIR)/usr/sbin/inetd
	if [ ! -f $(TARGET_DIR)/etc/inetd.conf ]; then \
		$(INSTALL) -D -m 0644 $(@D)/etc.sample/inetd.conf $(TARGET_DIR)/etc/inetd.conf; \
		$(SED) "s/^\([a-z]\)/#\1/;" $(TARGET_DIR)/etc/inetd.conf; \
	fi
endef

$(eval $(generic-package))
