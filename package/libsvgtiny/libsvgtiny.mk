################################################################################
#
# libsvgtiny
#
################################################################################

LIBSVGTINY_SITE = http://git.netsurf-browser.org/libsvgtiny.git
LIBSVGTINY_SITE_METHOD = git
LIBSVGTINY_VERSION = ea9d99fc8b231c22d06168135e181d61f4eb2f06
LIBSVGTINY_INSTALL_STAGING = YES
LIBSVGTINY_DEPENDENCIES = libxml2 host-gperf host-pkgconf
LIBSVGTINY_LICENSE = MIT
LIBSVGTINY_LICENSE_FILES = README

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
