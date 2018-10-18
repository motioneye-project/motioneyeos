################################################################################
#
# traceroute
#
################################################################################

TRACEROUTE_VERSION = 2.1.0
TRACEROUTE_SITE = http://downloads.sourceforge.net/traceroute/traceroute/traceroute-$(TRACEROUTE_VERSION)

TRACEROUTE_LICENSE = GPL-2.0+, LGPL-2.1+
TRACEROUTE_LICENSE_FILES = COPYING COPYING.LIB

define TRACEROUTE_BUILD_CMDS
	$(TARGET_MAKE_ENV) VPATH=$(STAGING_DIR)/usr/lib $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE" -C $(@D)
endef

define TRACEROUTE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		DESTDIR=$(TARGET_DIR) prefix=/usr install \
		INSTALL=$(INSTALL) -C $(@D)
endef

$(eval $(generic-package))
