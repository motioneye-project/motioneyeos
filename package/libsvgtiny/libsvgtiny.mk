################################################################################
#
# libsvgtiny
#
################################################################################

LIBSVGTINY_SITE = http://git.netsurf-browser.org/libsvgtiny.git
LIBSVGTINY_SITE_METHOD = git
LIBSVGTINY_VERSION = ea9d99fc8b231c22d06168135e181d61f4eb2f06
LIBSVGTINY_INSTALL_STAGING = YES
LIBSVGTINY_DEPENDENCIES = \
	libxml2 host-gperf host-pkgconf host-netsurf-buildsystem
LIBSVGTINY_LICENSE = MIT
LIBSVGTINY_LICENSE_FILES = README

# The libsvgtiny build system cannot build both the shared and static
# libraries. So when the Buildroot configuration requests to build
# both the shared and static variants, we build only the shared one.
ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
LIBSVGTINY_COMPONENT_TYPE = lib-shared
else
LIBSVGTINY_COMPONENT_TYPE = lib-static
endif

define LIBSVGTINY_CONFIGURE_CMDS
	ln -sf $(HOST_DIR)/share/netsurf-buildsystem $(@D)/build
endef

define LIBSVGTINY_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) PREFIX=/usr \
		COMPONENT_TYPE=$(LIBSVGTINY_COMPONENT_TYPE)
endef

define LIBSVGTINY_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(STAGING_DIR) \
		COMPONENT_TYPE=$(LIBSVGTINY_COMPONENT_TYPE) install
endef

define LIBSVGTINY_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) PREFIX=/usr DESTDIR=$(TARGET_DIR) \
		COMPONENT_TYPE=$(LIBSVGTINY_COMPONENT_TYPE) install
endef

$(eval $(generic-package))
