################################################################################
#
# pax-utils
#
################################################################################

PAX_UTILS_VERSION = 0.7
PAX_UTILS_SITE = http://distfiles.gentoo.org/distfiles
PAX_UTILS_SOURCE = pax-utils-$(PAX_UTILS_VERSION).tar.xz
PAX_UTILS_LICENSE = GPLv2
PAX_UTILS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBCAP),y)
PAX_UTILS_DEPENDENCIES += libcap
PAX_UTILS_USE_CAP = USE_CAP=yes
endif

# libcap is only useful for pspax (a running system)
HOST_PAX_UTILS_DEPENDENCIES =

# lddtree and symtree need bash
ifeq ($(BR2_PACKAGE_BASH),)
define PAX_UTILS_REMOVE_BASH_TOOLS
	rm -f $(TARGET_DIR)/usr/bin/{lddtree,symtree}
endef
endif
PAX_UTILS_POST_INSTALL_TARGET_HOOKS += PAX_UTILS_REMOVE_BASH_TOOLS

define HOST_PAX_UTILS_BUILD_CMDS
	$(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D)
endef

define PAX_UTILS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) $(PAX_UTILS_USE_CAP) -C $(@D)
endef

define HOST_PAX_UTILS_INSTALL_CMDS
	$(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D) DESTDIR="$(HOST_DIR)" install
endef

define PAX_UTILS_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
