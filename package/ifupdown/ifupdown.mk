################################################################################
#
# ifupdown
#
################################################################################

IFUPDOWN_VERSION = 0.7.49
IFUPDOWN_SOURCE = ifupdown_$(IFUPDOWN_VERSION).tar.xz
IFUPDOWN_SITE = http://snapshot.debian.org/archive/debian/20140923T221921Z/pool/main/i/ifupdown
IFUPDOWN_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)
IFUPDOWN_LICENSE = GPLv2+
IFUPDOWN_LICENSE_FILES = COPYING

define IFUPDOWN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -D'IFUPDOWN_VERSION=\"$(IFUPDOWN_VERSION)\"'" \
		-C $(@D)
endef

# install doesn't overwrite
define IFUPDOWN_INSTALL_TARGET_CMDS
	$(RM) $(TARGET_DIR)/sbin/{ifdown,ifquery}
	$(TARGET_MAKE_ENV) $(MAKE) BASEDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
