################################################################################
#
# libsvgtiny
#
################################################################################

LIBSVGTINY_SITE = svn://svn.netsurf-browser.org/trunk/libsvgtiny
LIBSVGTINY_VERSION = 12121
LIBSVGTINY_INSTALL_STAGING = YES
LIBSVGTINY_DEPENDENCIES = libxml2 host-gperf host-pkgconf

define LIBSVGTINY_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) PREFIX=/usr
endef

define LIBSVGTINY_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(STAGING_DIR) install
endef

define LIBSVGTINY_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
