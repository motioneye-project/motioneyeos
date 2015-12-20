################################################################################
#
# ifupdown
#
################################################################################

IFUPDOWN_VERSION = 0.8.2
IFUPDOWN_SOURCE = ifupdown_$(IFUPDOWN_VERSION).tar.xz
IFUPDOWN_SITE = http://snapshot.debian.org/archive/debian/20151205T042642Z/pool/main/i/ifupdown
IFUPDOWN_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)
IFUPDOWN_LICENSE = GPLv2+
IFUPDOWN_LICENSE_FILES = COPYING

define IFUPDOWN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -std=gnu99 -D'IFUPDOWN_VERSION=\"$(IFUPDOWN_VERSION)\"'" \
		-C $(@D)
endef

# install doesn't overwrite
define IFUPDOWN_INSTALL_TARGET_CMDS
	$(RM) $(TARGET_DIR)/sbin/{ifdown,ifquery}
	$(TARGET_MAKE_ENV) $(MAKE) BASEDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
