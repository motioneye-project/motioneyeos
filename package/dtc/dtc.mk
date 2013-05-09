#############################################################
#
# dtc
#
#############################################################

DTC_VERSION         = e4b497f367a3b2ae99cc52089a14a221b13a76ef
DTC_SITE            = git://git.jdl.com/software/dtc.git
DTC_LICENSE         = GPLv2+/BSD-2c
DTC_LICENSE_FILES   = README.license GPL
# Note: the dual-license only applies to the library.
#       The DT compiler (dtc) is GPLv2+, but we do not install it.
DTC_INSTALL_STAGING = YES

define DTC_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS)    \
	$(MAKE) -C $(@D) PREFIX=/usr libfdt
endef

# libfdt_install is our own install rule added by our patch
define DTC_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) PREFIX=/usr libfdt_install
endef

define DTC_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) PREFIX=/usr libfdt_install
endef

define DTC_CLEAN_CMDS
	$(MAKE) -C $(@D) libfdt_clean
endef

$(eval $(generic-package))
