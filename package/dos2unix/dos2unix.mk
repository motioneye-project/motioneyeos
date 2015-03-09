################################################################################
#
# dos2unix
#
################################################################################

DOS2UNIX_VERSION = 7.0
DOS2UNIX_SITE = http://waterlan.home.xs4all.nl/dos2unix
DOS2UNIX_DEPENDENCIES = host-gettext
DOS2UNIX_LICENSE = BSD-2c
DOS2UNIX_LICENSE_FILES = COPYING.txt

define HOST_DOS2UNIX_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define HOST_DOS2UNIX_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		install DESTDIR=$(HOST_DIR)
endef

$(eval $(host-generic-package))
