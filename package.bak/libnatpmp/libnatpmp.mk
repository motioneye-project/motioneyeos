################################################################################
#
# libnatpmp
#
################################################################################

LIBNATPMP_VERSION = 20150609
LIBNATPMP_SITE = http://miniupnp.free.fr/files
LIBNATPMP_INSTALL_STAGING = YES
LIBNATPMP_LICENSE = BSD-3c
LIBNATPMP_LICENSE_FILES = LICENSE

define LIBNATPMP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)"
endef

define LIBNATPMP_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		PREFIX=$(STAGING_DIR) \
		HEADERS='declspec.h natpmp.h' \
		$(TARGET_CONFIGURE_OPTS) install
endef

define LIBNATPMP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		PREFIX=$(TARGET_DIR) \
		$(TARGET_CONFIGURE_OPTS) install
endef

$(eval $(generic-package))
