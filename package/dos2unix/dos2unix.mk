################################################################################
#
# dos2unix
#
################################################################################

DOS2UNIX_VERSION = 7.4.0
DOS2UNIX_SITE = http://waterlan.home.xs4all.nl/dos2unix
DOS2UNIX_LICENSE = BSD-2-Clause
DOS2UNIX_LICENSE_FILES = COPYING.txt
DOS2UNIX_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_BUSYBOX),busybox) \
	$(TARGET_NLS_DEPENDENCIES)

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
DOS2UNIX_MAKE_OPTS += ENABLE_NLS=1
DOS2UNIX_MAKE_OPTS += LIBS_EXTRA=$(TARGET_NLS_LIBS)
else
# Should be defined to empty to disable NLS support
DOS2UNIX_MAKE_OPTS += ENABLE_NLS=
endif

ifeq ($(BR2_USE_WCHAR),)
DOS2UNIX_MAKE_OPTS += UCS=
endif

define DOS2UNIX_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(DOS2UNIX_MAKE_OPTS)
endef

define DOS2UNIX_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) \
		$(DOS2UNIX_MAKE_OPTS) install
endef

define HOST_DOS2UNIX_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) ENABLE_NLS=
endef

define HOST_DOS2UNIX_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) prefix=$(HOST_DIR) ENABLE_NLS= \
		install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
