################################################################################
#
# ifupdown
#
################################################################################

IFUPDOWN_VERSION = 0.8.16
IFUPDOWN_SOURCE = ifupdown_$(IFUPDOWN_VERSION).tar.xz
IFUPDOWN_SITE = http://snapshot.debian.org/archive/debian/20160922T165503Z/pool/main/i/ifupdown
IFUPDOWN_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)
IFUPDOWN_LICENSE = GPL-2.0+
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

# We need to switch from /bin/ip to /sbin/ip
IFUPDOWN_DEFN_FILES = can inet inet6 ipx link meta
define IFUPDOWN_MAKE_IP_IN_SBIN
	for f in $(IFUPDOWN_DEFN_FILES) ; do \
		$(SED) 's,/bin/ip,/sbin/ip,' $(@D)/$$f.defn ; \
	done
endef
IFUPDOWN_POST_PATCH_HOOKS += IFUPDOWN_MAKE_IP_IN_SBIN

$(eval $(generic-package))
